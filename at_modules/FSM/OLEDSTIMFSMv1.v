`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Columbia U
// Engineer: Adriaan Taal
// 
// Create Date:    17:13:42 08/26/2017 
// Design Name: 
// Module Name:    FSM_v9
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision:
//		v1 - [adriaan] 
//////////////////////////////////////////////////////////////////////////////////


module OLEDSTIMFSMv1(
	//out to FPGA
	LED_ON_CLK_EN,		//enable the laser synchronous led emission time gate
	NEXT_PATTERN, 
	
	//out to IC
	dis_led, 			   //1b
	PROBE_SEL, 	//2b
	ADDR, 				//6b
	SIDE,		 			//1b
	BETA,		 			//1b
	LOAD,
	
	//from FPGA
	stim_pulses,                     //the amount of stim pulses to count before resetting the FSM
	stim_frames,                    //the amount of frames to count before rese
	dis_led_mask,
	PATTERN_VALID,					//
	pll_locked,
	LED_ON_CLK_DIVCNT,     //prescaled clock
	en,				//fsm enable
	clk,			//FSM switching clock
	rst			//reset
);


//output to fpga
output reg LED_ON_CLK_EN; 
output reg NEXT_PATTERN;
output reg LOAD;

//ouptut to IC
output wire [1:0] PROBE_SEL;
output wire [5:0] ADDR;
output wire SIDE;
output wire BETA;
output wire dis_led;


//input
input wire en;
input wire clk;
input wire rst;
input wire PATTERN_VALID;
input wire pll_locked;
input wire LED_ON_CLK_DIVCNT;
input wire [31:0] stim_pulses;
input wire [31:0] stim_frames;
input wire [1023:0] dis_led_mask;

//states
parameter IDLE = 3'b000;
parameter STIM = 3'b001;
parameter REST = 3'b010;
parameter SET_LOAD = 3'b011;
parameter NEXT_PIX = 3'b100;

//internals
reg [31:0] pulses_cnt;
reg [31:0] frames_cnt;
reg [9:0] readfromADDR;
reg [3:0] dataSettleCounter;

//state internal
reg [2:0] state;
assign PROBE_SEL = readfromADDR[9:8];
assign ADDR = readfromADDR[7:2];
assign SIDE = readfromADDR[1];
assign BETA = readfromADDR[0];
assign dis_led = dis_led_mask[readfromADDR];

//sequential logic
always @(posedge clk or posedge rst) begin
	if(rst) begin
		//outputs
		LED_ON_CLK_EN  <= 1'b0;
		NEXT_PATTERN  <= 1'b0;
		LOAD  <= 1'b0;
		
		//internals
		readfromADDR 	<= 10'b0;
		frames_cnt 	<= 32'b0;
		dataSettleCounter 	<= 4'b0;
		
		//state
		state <= IDLE;
	end
	
	else begin
	
		case(state)
			IDLE: begin
				//outputs
				LED_ON_CLK_EN 	<= 1'b0;
				NEXT_PATTERN  <= 1'b0;
				LOAD  <= 1'b0;
				
				//internals
				readfromADDR 	<= 10'b0;
				frames_cnt 	<= 32'b0;
				dataSettleCounter 	<= 4'b0;
		
				//state
				if(en) begin
					state <= STIM;
				end
			end
			
			
			STIM: begin  //record for designated periods_cnt and move on. otherwise stay in state.
				//outputs
				LED_ON_CLK_EN 	<= 1'b1;
				NEXT_PATTERN  <= 1'b0;
				LOAD  <= 1'b0;
				
				//internals				
				readfromADDR 			<= 10'b0;
				dataSettleCounter 	<= 4'b0;
				
				//state
				if((pulses_cnt >= stim_pulses)) begin //when # of pulses is reached
					state <= REST;
				end else begin
					state <= STIM;
				end
			end
			

			REST: begin //rest for designated periods_cnt and return to STIM while 
				//outputs
				LED_ON_CLK_EN 	<= 1'b0;
				NEXT_PATTERN  <= 1'b0;							
				LOAD  <= 1'b0;
				
				//internals				
				readfromADDR 	<= 10'b0;
				dataSettleCounter 	<= 4'b0;
				
				//state
				if((frames_cnt >= stim_frames)) begin   //when # of frames is reached, need to go to flash next pattern
					state <= SET_LOAD;
					
				end else begin
						if((pulses_cnt >= stim_pulses)) begin //when # of pulses is reached
								state <= STIM;
						end else begin
								state <= REST; //stay in rest
						end
				end
			end
					
			SET_LOAD: begin //send request for data to IC. This is technically a 3-state process (request, sample, send&next)  combined into 2 states
				//outputs
				LED_ON_CLK_EN <= 1'b0;
				NEXT_PATTERN	<= 1'b0;
				
				//internals				
				frames_cnt 	<= 32'b0;
				
				//state
//					if (dataSettleCounter >= data_wait_cycles) begin
						LOAD <= 1'b1;									//Assert LOAD to flash DIS_LED and PIX_OFF, asserted 1 clock cycle after ADDR, only on the first frame in the pattern
						state <= NEXT_PIX;
//					end else begin
//						dataSettleCounter <= dataSettleCounter + 1'b1;
//						state <= SET_LOAD;
//					end
			end
			
			
			NEXT_PIX: begin //send data to FIFO, loop to new address
				//outputs
				LED_ON_CLK_EN <= 1'b0;
				LOAD <= 1'b0;
				
				//internals
				dataSettleCounter <= 4'b0;
				frames_cnt 	<= 32'b0;
								
				//state and internals
				if(readfromADDR >= 10'd1023) begin //when the final address is surpassed. This ensures READ_PIX state will still be reached for pixel 1023
					readfromADDR <= 10'b0;    // go back to first pixel
					NEXT_PATTERN	<= 1'b1;    // request new pattern from FIFOc
					state <= IDLE;
				end else begin
					readfromADDR <= readfromADDR + 1'b1; //send new address to the IC to settle for new data request
					state <= SET_LOAD;
				end 
			end
			
			
						
						
			default: begin //same behaviour as reset clause
				//outputs
				LED_ON_CLK_EN 	<= 1'b0;
				LOAD <= 1'b0;
				NEXT_PATTERN	<= 1'b0;
				
				//internals
				readfromADDR 	<= 10'b0;
				frames_cnt 	<= 32'b0;
				dataSettleCounter 	<= 4'b0;
				
				//state
				state <= IDLE;
			end
			
		endcase
	end
end

//counter for the number of windows that have been
//because SPAD_ON_CLK and LED_ON_CLK are synchronous, we just count on SPAD_ON_CLK
always @(posedge LED_ON_CLK_DIVCNT) begin
	if (((state == STIM) || (state == REST)) && (pll_locked == 1'b1)) begin
		pulses_cnt <= pulses_cnt + 1;
	end else begin
		pulses_cnt <= 32'b0;
	end
end

endmodule

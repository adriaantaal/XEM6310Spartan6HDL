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
//		v1 - [adriaan] Empty box with correct in and outputs
//		v2 - [jaebin] State machine first attempt
//		v3 - [adriaan] Fixed errors, verified and made synthesizable. Moved the counter to toplevel.
//		v4 - [adriaan] added the hot pixel masking, and the LOAD signal
//		v5 - [adriaan] made the data_wait counter programmable
//		v6 - [adriaan] added extra data bit for Nov2018 tapeout
//							added dis_led and LED_ON_CLK_EN
//		v7 - [adriaan] added alternating recording phase for shared counter
//							Requires full readout cycle for BETA =0 and BETA=1	
//							Correctly asserted LOAD when the addressing has settled
//		v8 - [adriaan] Added input pattern_frames for integration time per pattern before going back to idle state
//							Added input PATTERN_VALID to start recording 
//							Added output NEXT_PATTERN to strobe when current pattern is done (when enabled) that transfers next pattern to DIS_LED_MASK
//		v9 - Removed the alternating BETA for the new chip, as it has per-pixel memory
// Additional Comments: 
//			Nomenclature of integration periods: 
//									 1 period  = 1x SPAD_ON_CLK 
//				many periods => 1 frame   = 1x DOUT sent to FIFO  This is the shortest time interval saved.
//				many frames  => 1 pattern = 1x pattern_frames     This is the longest time interval with constant pattern.
//		v10 - Made the fsm possible for single-shot.
//				Check for FSM_en only once to advance from IDLE to CLEAR state
//////////////////////////////////////////////////////////////////////////////////


module FSM_v10_quad(
	//out to IC
	pix_off, 			//1b
	dis_led, 			//1b
	PROBE_SEL, 			//2b
	ADDR, 				//6b
	SIDE,		 			//1b
	BETA,		 			//1b
	MEM_CLEAR,			//global IC reset
	READ_EN,				//request to IC to update data
	SPAD_ON_CLK_EN,	//enable the laser synchronous delayed photon gathering time
	LED_ON_CLK_EN,		//enable the laser synchronous led emission time gate
	DIN,					//data from IC 
	LOAD,					//enable for the pix_off and dis_led
	
	//from FPGA
	pix_off_mask,	//1024 bit hot pixel mask
	dis_led_mask,	//1024 bit defective LED mask
	spad_on_clk,	//20MHz from PLL
	pll_locked,		//locked signal, dont count the
	frame_periods,	//number of laser_clk periods to gather photons within one frame
	pattern_frames,	//amount of frames at current pattern before returning back to 
	data_wait_cycles, //time to wait to settle address in the chip, determines overhead
	PATTERN_VALID,		//pattern flashed to OLED is valid
	NEXT_PATTERN,	//pattern is done, request for next pattern
	en,				//fsm enable
	clk,				//FSM switching clock
	rst,				//reset
	dout,				//16bit output to fifo, [10 address bits][6-bit data] 
	req_fifowr		//fifo write request strobe 
);

//output
output wire [1:0] PROBE_SEL;
output wire [5:0] ADDR;
output wire SIDE;
output wire BETA;

output wire pix_off;
output wire dis_led;

output reg [15:0] dout;
output reg req_fifowr;
output reg READ_EN;
output reg MEM_CLEAR;
output reg SPAD_ON_CLK_EN; 
output reg LED_ON_CLK_EN; 
output reg LOAD;
output reg NEXT_PATTERN;

//input
input wire [1023:0] pix_off_mask;
input wire [1023:0] dis_led_mask;
input wire [5:0] DIN;
input wire en;
input wire clk;
input wire rst;
input wire [31:0] frame_periods;
input wire [3:0] data_wait_cycles;
input wire [31:0] pattern_frames;
input wire spad_on_clk;
input wire pll_locked;
input wire PATTERN_VALID;

//states
parameter IDLE = 3'b000;
parameter CLEAR = 3'b001;
parameter RECORD = 3'b010;
parameter READ_PIX = 3'b011;
parameter NEXT_PIX_AND_FIFO = 3'b100;

//internals
reg [31:0] periods_cnt;
reg [31:0] frames_cnt;
reg [9:0] readfromADDR;
reg [3:0] dataInCounter;

//state internal
reg [2:0] state;

//concurrent logic
assign PROBE_SEL = readfromADDR[9:8];
assign ADDR = readfromADDR[7:2];
assign SIDE = readfromADDR[1];
assign BETA = readfromADDR[0];
assign dis_led = dis_led_mask[readfromADDR];
assign pix_off = pix_off_mask[readfromADDR];


//sequential logic
always @(posedge clk or posedge rst) begin
	if(rst) begin
		//outputs
		dout 				<= 16'b0;
		req_fifowr		<= 1'b0;
		READ_EN			<= 1'b0;
		SPAD_ON_CLK_EN <= 1'b0;
		LED_ON_CLK_EN  <= 1'b0;
		MEM_CLEAR 		<= 1'b0;
		LOAD 				<= 1'b0;
		NEXT_PATTERN	<= 1'b0;
		
		//internals
		readfromADDR 	<= 10'b0;
		frames_cnt 	<= 32'b0;
		dataInCounter 	<= 4'b0;
		
		//state
		state <= IDLE;
	end
	
	else begin
	
		case(state)
			IDLE: begin	//idle, this is returning state for BETA <= 0
				dout 				<= 16'b0;
				req_fifowr 		<= 1'b0;
				READ_EN 			<= 1'b1;
				SPAD_ON_CLK_EN <= 1'b0;
				LED_ON_CLK_EN 	<= 1'b0;
				MEM_CLEAR 		<= 1'b1;			//assert mem_clear 
				LOAD 				<= 1'b0;
				NEXT_PATTERN	<= 1'b0;
				
				//internals
				readfromADDR	<= 10'b0;
				dataInCounter 	<= 4'b0;
				
				//state
				if(en) begin
					state <= CLEAR;
				end
			end
		
			CLEAR: begin //clear mem, this is the returning state after finishing one frame
				dout <= 16'b0;
				req_fifowr <= 1'b0;
				READ_EN <= 1'b1; 
				SPAD_ON_CLK_EN <= 1'b0;
				LED_ON_CLK_EN <= 1'b0;
				MEM_CLEAR <= 1'b1;			//assert mem_clear
				LOAD 			<= 1'b0;
				
				//internals
				readfromADDR	<= 10'b0;
				dataInCounter 	<= 4'b0;
				
				//state
				if(PATTERN_VALID && (periods_cnt == 0)) begin	
					state <= RECORD;		//start or continue the loop
				end else begin
					state <= CLEAR; 			//wait in the CLEAR state before PATTERN_VALID
				end
			end
			
			RECORD: begin //record for designated periods_cnt and move on. otherwise stay in state.
				dout <= 16'b0;
				req_fifowr <= 1'b0;
				READ_EN <= 1'b1;
				SPAD_ON_CLK_EN <= 1'b1; 	//enable the SPAD_ON from PLL to the GPIO
				LED_ON_CLK_EN <= 1'b1; 		//enable the LED_ON from PLL to the GPIO
				MEM_CLEAR <= 1'b0;			//deassert mem_clear
				LOAD 			<= 1'b0;
				NEXT_PATTERN	<= 1'b0;
				
				//internals				
				readfromADDR <= 10'b0;
				dataInCounter 	<= 4'b0;
				
				if((periods_cnt >= frame_periods)) begin //when # of windows is reached
					state <= READ_PIX;
				end else begin
					state <= RECORD;
				end
			end

			//dout, readfromADDR, are latched so they are not defined in both states
			//16bit output with MSB addresses and LSB values will be read, it has 12.5ns to settle
			//If it requires more than 12.5ns of settling time, we will create a third state
			READ_PIX: begin //send request for data to IC. This is technically a 3-state process (request, sample, send&next)  combined into 2 states
				//outputs
				SPAD_ON_CLK_EN <= 1'b0;
				LED_ON_CLK_EN <= 1'b0;
				MEM_CLEAR <= 1'b0;
				req_fifowr <= 1'b0; 							//data should not be send to fifo
				READ_EN <= 1'b1;								//send read request to the IC	
				NEXT_PATTERN	<= 1'b0;
				
				if (frames_cnt == 32'b0) begin
				   LOAD <= 1'b1;									//Assert LOAD to flash DIS_LED and PIX_OFF, asserted 1 clock cycle after ADDR, only on the first frame in the pattern
				end else begin
				   LOAD <= 1'b0;									
				end			
				
				
				//internals
				//readfromADDR <= is latched from the previous state
															
				//set wait counter for state change to give it 8x as many clock cylces to read out the data
				if (dataInCounter >= data_wait_cycles) begin
					dout <= {readfromADDR, DIN}; //Even though readfromADDR is 10 bits instantiated for compatibility
					state <= NEXT_PIX_AND_FIFO;
					dataInCounter <= 4'b0;
				end else begin
					dataInCounter <= dataInCounter + 1'b1;
					state <= READ_PIX;
				end
				
			end
			
			NEXT_PIX_AND_FIFO: begin //send data to FIFO, loop to new address
				//outputs
				SPAD_ON_CLK_EN <= 1'b0;
				LED_ON_CLK_EN <= 1'b0;
				MEM_CLEAR <= 1'b0;
				READ_EN <= 1'b1;
				//dout <= is latched from the previous state
				req_fifowr <= 1'b1; 	//send it bro!!
				LOAD <= 1'b0;
				
				//internals
				dataInCounter 	<= 4'b0;
				
				//state
				if(readfromADDR >= 10'd1023) begin //when the final address is surpassed. The READ_PIX state needs still be reached for pixel 1023
					readfromADDR <= 10'b0;    // go back to first pixel
					
					if (frames_cnt >= pattern_frames) begin //done with the whole pattern. Single shot is done. Load next pattern.
						state <= IDLE;
						NEXT_PATTERN	<= 1'b1;
						frames_cnt 	<= 32'b0;
					end else begin
						state <= CLEAR;  //clear memory and do another frame
						frames_cnt <= frames_cnt + 1;  //after reading from all pixels, increase the frames_cnt
						NEXT_PATTERN	<= 1'b0;
					end					
							
				end else begin //if not yet at final pixel
					state <= READ_PIX;
					readfromADDR <= readfromADDR + 1'b1; //send new address to the IC to settle for new data request
					NEXT_PATTERN	<= 1'b0;
				end
			end
						
						
			default: begin //same behaviour as reset clause
				//outputs
				dout <= 16'b0;
				req_fifowr	<= 1'b0;
				READ_EN		<= 1'b0;
				SPAD_ON_CLK_EN <= 1'b0;
				LED_ON_CLK_EN <= 1'b0;
				MEM_CLEAR 	<= 1'b0;
				LOAD <= 1'b0;
				NEXT_PATTERN	<= 1'b0;
				//internals
				readfromADDR <= 10'b0;
				dataInCounter <= 4'b0;
				frames_cnt <= 32'b0;
				//state
				state <= IDLE;
			end
			
		endcase
	end
end

//counter for the number of windows that have been
//because SPAD_ON_CLK and LED_ON_CLK are synchronous, we just count on SPAD_ON_CLK
always @(negedge spad_on_clk) begin
	if ((state == RECORD) && (pll_locked == 1'b1)) begin
		periods_cnt <= periods_cnt + 1;
	end else begin
		periods_cnt <= 32'b0;
	end
end

endmodule

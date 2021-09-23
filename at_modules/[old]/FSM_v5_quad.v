`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Columbia U
// Engineer: Jaebin Choi and Adriaan Taal
// 
// Create Date:    17:13:42 08/26/2017 
// Design Name: 
// Module Name:    FSM_v1 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision:
//		v1 - [adriaan] Empty box with correct in and outputs
//		v2 - [jaebin] State machine created
//		v3 - [adriaan] verified and synthesized. Moved the counter to toplevel.
//		v4 - [adriaan] added the hot pixel masking, and the LOAD signal
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
//Feedback on v2:

// Make sure you define all outputs in all states!
// Clean up the unused inputs and outputs, dont uncomment them, just remove 
// In state Idle you are pushing the data into the fifo. There is no guarantee this data is valid
// Made sure the counter value was again defined for every state

// instead of posedge(clkb) -> negedge(clk)
// nested case statements? Not a good idea

// be concise, dont put the same statement in the if and the else 
// mem_clear was not set low again in the record state
// what is the difference between read_toggle and read_EN? according to the code they are the same!
// if we want to do negative edge sampling, its better to have another state and do a double 
// use the internal readfromADDR as a counter, and then set the corresponding outputs from that counter

module FSM_v5_quad(
	//to IC
	pix_off, 			//1b
	PROBE_SEL, 			//1b
	ADDR, 				//6b
	PIX_SEL, 			//2b
	MEM_CLEAR,			//global IC reset
	READ_EN,				//request to IC to update data
	SPAD_ON_CLK_EN,	//enable the laser synchronous delayed photon gathering time
	DIN,					//data from IC
	LOAD,			//enable for the pix_off
	
	//from FPGA
	pix_off_mask,//512 bit hot pixel mask
	spad_on_clk,	//20MHz from PLL
	pll_locked,		//locked signal, dont open spad_on unless its locked
	window_cycles,	//number of laser_clk windows to gather photons
	delay,			//--not implemented--
	delay_cycles,	//--not implemented--
	en,				//fsm enable
	clk,				//80 MHz clock, resolves to Tclk/2 pixel readout speed
	rst,				//reset
	dout,				//16bit output to fifo, [9 address bits][00][5-bit data] 
	req_fifowr		//fifo write enable
);

//output
output wire [1:0] PROBE_SEL;
output wire [5:0] ADDR;
output wire [1:0] PIX_SEL;

output reg [15:0] dout;
output reg req_fifowr;
output reg READ_EN;
output reg MEM_CLEAR;
output reg pix_off;
output reg SPAD_ON_CLK_EN; 
output reg LOAD;

//input
input wire [511:0] pix_off_mask;
input wire [4:0] DIN;
input wire en;
input wire clk;
input wire rst;
input wire delay;
input wire [31:0] window_cycles;
input wire [31:0] delay_cycles;
input wire spad_on_clk;
input wire pll_locked;

//states
parameter IDLE = 3'b000;
parameter CLEAR = 3'b001;
parameter RECORD = 3'b010;
parameter READ_PIX = 3'b011;
parameter NEXT_PIX_AND_FIFO = 3'b100;

//internals
reg [31:0] windows_cnt;
reg [10:0] readfromADDR;
reg [15:0] dout_flipped;
parameter DATA_WAIT = 4'b1000;

//state internal
reg [2:0] state;
reg [3:0] dataInCounter;

//concurrent logic
assign PROBE_SEL = readfromADDR[9:0];
assign ADDR = readfromADDR[7:2];
assign PIX_SEL = readfromADDR[1:0];

//sequential logic
always @(posedge clk or posedge rst) begin
	if(rst) begin
		//outputs
		dout <= 16'b0;
		req_fifowr	<= 1'b0;
		READ_EN		<= 1'b0;
		pix_off		<= 1'b0;
		SPAD_ON_CLK_EN <= 1'b0;
		MEM_CLEAR 	<= 1'b0;
		//internals
		readfromADDR <= 11'b0;
		//state
		state <= IDLE;
		dataInCounter <= 4'b0;
	end
	
	else begin
	
		case(state)
			IDLE: begin
				dout <= 16'b0;
				req_fifowr <= 1'b0;
				pix_off		<= 1'b0;
				READ_EN <= 1'b1;
				SPAD_ON_CLK_EN <= 1'b0;
				MEM_CLEAR <= 1'b0;
				//internals
				readfromADDR	<= 11'b0;
				//state
				if(en) begin
					state <= CLEAR;
				end
			end
		
			CLEAR: begin //clear mem
				pix_off		<= 1'b0;
				dout <= 16'b0;
				req_fifowr <= 1'b0;
				READ_EN <= 1'b1; //edit just now
				SPAD_ON_CLK_EN <= 1'b0;
				MEM_CLEAR <= 1'b1;			//assert mem_clear
				//internals
				readfromADDR	<= 11'b0;
				//state
				if(en && (windows_cnt == 0)) begin	
					state <= RECORD;		//start or continue the loop
				end else begin
					state <= IDLE; 		//hop back to idle
				end
			end
			
			RECORD: begin //record for designated windows_cnt and move on. otherwise stay in state.
				pix_off		<= 1'b0;
				dout <= 16'b0;
				req_fifowr <= 1'b0;
				READ_EN <= 1'b1;
				SPAD_ON_CLK_EN <= 1'b1; 	//enable the SPAD_ON from PLL to the GPIO
				MEM_CLEAR <= 1'b0;			//deassert mem_clear
				//internals				
				readfromADDR <= 11'b0;
				
				if((windows_cnt >= window_cycles)) begin //when # of windows is reached
					state <= READ_PIX;
					dataInCounter <= 4'b0;
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
				MEM_CLEAR <= 1'b0;
				req_fifowr <= 1'b0; 							//data should not be send to fifo
				READ_EN <= 1'b1;								//send read request to the IC	
				
				//internals
				//readfromADDR <= is latched from the previous state
				
				//set pix_off
				if (pix_off_mask[readfromADDR] == 1'b1) begin
					pix_off <= 1'b1;
				end else begin
					pix_off <= 1'b0;
				end
				
				//set wait counter for state change to give it 8x as many clock cylces to read out the data
				if (dataInCounter >= DATA_WAIT) begin
					dout <= {readfromADDR , DIN}; //fix0905
					state <= NEXT_PIX_AND_FIFO;
					dataInCounter <= 4'b0;
				end else begin
					dataInCounter <= dataInCounter + 1'b1;
					state <= READ_PIX;
				end
				
			end
			
			NEXT_PIX_AND_FIFO: begin //send data to FIFO, loop to new address
				//outputs
				pix_off		<= 1'b0;
				SPAD_ON_CLK_EN <= 1'b0;
				MEM_CLEAR <= 1'b0;
				READ_EN <= 1'b1;
				//dout <= is latched from the previous state
				req_fifowr <= 1'b1; 	//send it bro!!
				
				//internals

				//state
				if(readfromADDR >= 11'd1023) begin //when the final address is surpassed. The READ_PIX state needs still be reached for pixel 511
					state <= CLEAR;
					readfromADDR <= 11'b0;
				end else begin
					state <= READ_PIX;
					readfromADDR <= readfromADDR + 1'b1; //send new address to the IC to settle for new data request
				end
			end
						
						
			default: begin //same behaviour as reset clause
				//outputs
				dout <= 16'b0;
				req_fifowr	<= 1'b0;
				pix_off		<= 1'b0;
				READ_EN		<= 1'b0;
				SPAD_ON_CLK_EN <= 1'b0;
				MEM_CLEAR 	<= 1'b0;
				//internals
				readfromADDR <= 11'b0;
				//state
				state <= IDLE;
				dataInCounter <= 4'b0;		
			end
			
		endcase
	end
end

//counter for the number of windows that have been
always @(negedge spad_on_clk) begin
	if ((state == RECORD) && (pll_locked == 1'b1)) begin
		windows_cnt <= windows_cnt + 1;
	end else begin
		windows_cnt <= 32'b0;
	end
	
	if ((state == READ_PIX) && (pix_off_mask[readfromADDR] == 1'b1)) begin
		LOAD <= 1'b1;
	end else begin
		LOAD <= 1'b0;
	end
end

endmodule

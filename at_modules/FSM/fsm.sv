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

module spadfsm(	
	//to IC
	theaddr spadaddr,
//	output bit PROBE_SEL, 			//1b
//	output bit [5:0] ADDR, 				//6b
//	output bit [1:0] PIX_SEL, 			//2b
		
	output bit MEM_CLEAR,			//global IC reset
	output bit READ_EN,				//request to IC to update data
	output bit SPAD_ON_CLK_EN,	//enable the laser synchronous delayed photon gathering time
	output bit [15:0] dout,				//16bit output to fifo, [9 address bits][00][5-bit data]
	output bit req_fifowr,		//fifo write enable
	
	//from IC
	input logic [4:0] DIN,					//data from IC
		
	//from FPGA
	input logic spad_on_clk,	//20MHz from PLL
	input logic pll_locked,		//locked signal, dont open spad_on unless its locked
	input logic [1:0] window_cycles,	//number of laser_clk windows to gather photons
	input logic en,				//fsm enable
	input logic clk,				//80 MHz clock, resolves to Tclk/2 pixel readout speed
	input logic rst				//reset
	 
);

//states
parameter IDLE = 3'b000;
parameter CLEAR = 3'b001;
parameter RECORD = 3'b010;
parameter READ_PIX = 3'b011;
parameter NEXT_PIX_AND_FIFO = 3'b100;
parameter DATA_WAIT = 4'b1000;

//internals
reg [1:0] windows_cnt;
reg [9:0] readfromADDR;
reg [15:0] dout_flipped;

//state internal
reg [2:0] state;
reg [3:0] dataInCounter;

//concurrent logic
assign spadaddr.PROBE_SEL = readfromADDR[8];
assign spadaddr.ADDR = readfromADDR[7:2];
assign spadaddr.PIX_SEL = readfromADDR[1:0];

//sequential logic
always @(posedge clk or posedge rst) begin
	if(rst) begin
		//outputs
		dout <= 16'b0;
		req_fifowr	<= 1'b0;
		READ_EN		<= 1'b0;
		SPAD_ON_CLK_EN <= 1'b0;
		MEM_CLEAR 	<= 1'b0;
		//internals
		readfromADDR <= 10'b0;
		//state
		state <= IDLE;
		dataInCounter <= 4'b0;
	end
	
	else begin
	
		case(state)
			IDLE: begin
				dout <= 16'b0;
				req_fifowr <= 1'b0;
				READ_EN <= 1'b1;
				SPAD_ON_CLK_EN <= 1'b0;
				MEM_CLEAR <= 1'b0;
				//internals
				readfromADDR	<= 10'b0;
				//state
				if(en) begin
					state <= CLEAR;
				end
			end
		
			CLEAR: begin //clear mem
				dout <= 16'b0;
				req_fifowr <= 1'b0;
				READ_EN <= 1'b1; //edit just now
				SPAD_ON_CLK_EN <= 1'b0;
				MEM_CLEAR <= 1'b1;			//assert mem_clear
				//internals
				readfromADDR	<= 10'b0;
				//state
				if(en && (windows_cnt == 0)) begin	
					state <= RECORD;		//start or continue the loop
				end else begin
					state <= IDLE; 		//hop back to idle
				end
			end
			
			RECORD: begin //record for designated windows_cnt and move on. otherwise stay in state.
				dout <= 16'b0;
				req_fifowr <= 1'b0;
				READ_EN <= 1'b1;
				SPAD_ON_CLK_EN <= 1'b1; 	//enable the SPAD_ON from PLL to the GPIO
				MEM_CLEAR <= 1'b0;			//deassert mem_clear
				//internals				
				readfromADDR <= 10'b0;
				
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
//				if (dataInCounter >= DATA_WAIT) begin
//					dout <= {readfromADDR, 1'b0 , DIN}; //fix0905
//				end
				
				
				//internals
				//readfromADDR <= is latched from the previous state
				
				//state
				if (dataInCounter >= DATA_WAIT) begin
					dout <= {readfromADDR, 1'b0 , DIN}; //fix0905
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
				MEM_CLEAR <= 1'b0;
				READ_EN <= 1'b1;
				//dout <= is latched from the previous state
				req_fifowr <= 1'b1; 	//send it bro!!
				
				//internals

				//state
				if(readfromADDR >= 10'd511) begin //when the final address is surpassed. The READ_PIX state needs still be reached for pixel 511
					state <= CLEAR;
					readfromADDR <= 10'b0;
				end else begin
					state <= READ_PIX;
					readfromADDR <= readfromADDR + 1'b1; //send new address to the IC to settle for new data request
				end
			end
						
						
			default: begin //same behaviour as reset clause
				//outputs
				dout <= 16'b0;
				req_fifowr	<= 1'b0;
				READ_EN		<= 1'b1;
				SPAD_ON_CLK_EN <= 1'b0;
				MEM_CLEAR 	<= 1'b0;
				//internals
				readfromADDR <= 10'b0;
				//state
				state <= IDLE;
			end
			
		endcase
	end
end

//counter for the number of windows that have been
always @(negedge spad_on_clk) begin
	if ((state == RECORD) && (pll_locked == 1'b1)) begin
		windows_cnt <= windows_cnt + 1;
	end else begin
		windows_cnt <= 2'b0;
	end
	
end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Adriaan Taal
// 
// Create Date:    21:01:51 08/12/2018 
// Design Name: 
// Module Name:    SPI_write 
// Project Name: 	
// Target Devices: 
// Tool versions: 
// Description: 	This is the SPI_write master for the clunky SPI slave that was synthesized on the probeshank
//It works now!
//
//////////////////////////////////////////////////////////////////////////////////
//AT: v2 changes to make it work with 0107_SPI_00_MOM5_phy.v

//Removed SCLK and ce_SCLK to always be on (dont gate the clock)
//SLOAD is always high until transfer initiates
//Transfer initiation (LOAD=0) is on the moment when the state variable changes
//That way the next SCLK rising edge latches in the correct variable

//Changed all the counters to be outside the state change if statement
//Added an intermediate state that transfers the data (load =1, swr 1 -> 0)
//Added the MOSI while reading out, so the data into the chip is not reset
//Had to make the SDOUT assignment non-combinatorial inside the case statement 

//The bit orders are reversed in the shift, so I changed sdin = masterdata[NDATA-1-datawr_cnt]  

//Some other notes:
//FPGA is master, chip is slave

//SDOUT == MISO
//SDIN == MOSI
//SLOAD == SSELB
//SCLK should always be on
//When you are reading out data, you should still be shifting in data

//Timing diagram for MOSI
//SRESET = 0
//Preset WR = 1
//LOAD = 1
//When SRESET = 0, LOAD = 0, vector shifts records data via DIN on each rising edge of SCLK
//Then, LOAD = 1, the data is presented on the output data



//Timing diagram for MISO
//SRESET = 0
//Preset WR = 0
//LOAD = 1, the data is presented to the shift register
//When SRESET = 0, LOAD = 0, vector shifts onto DOUT on each rising edge
//Then, LOAD = 1, the data transfer is done



module SPI_write_atv2 (
//inputs
en,
masterdata,
clk,
rst,
sdout,

//outputs
swr,
sdin,
sload,
sreset,
datareadback
);

parameter NDATA = 48;
parameter STATE_IDLE = 0;
parameter STATE_SHIFT = 1;
parameter STATE_LOAD = 2;
parameter STATE_LOAD_TRANSFER = 3;
parameter STATE_SHIFT_READ = 4;

parameter LOAD_WAIT = 3'b010;

input en;
input [63:0] masterdata;
input clk;
input rst;
input sdout; //MISO

output reg swr;
output wire sdin; //MOSI
output reg sload;
output reg sreset;
output reg [63:0] datareadback; 

reg [5:0] datawr_cnt;
reg [5:0] datard_cnt;
reg [2:0] state;
reg [2:0] load_cnt;

//combinatorial logic
assign sdin = masterdata[NDATA-1-datawr_cnt]; 

//sequential logic
always @ (posedge (clk) or posedge (rst)) begin
	if(rst) begin
		//outputs
		swr <= 1'b1;
		sload <= 1'b1; 		//load always high until transfer initiates
		sreset <= 1'b1;
		datareadback <= 63'b0;
		
		//internals
		load_cnt <= 0;
		datawr_cnt <= 0;
		datard_cnt <= 0;
		
		//state
		state <= STATE_IDLE;
		
	end
	else begin
		case (state)
			STATE_IDLE : begin
				//outputs
				swr <= 1'b1;		//MOSI 
				sload <= 1'b1;		//load high
				sreset <= 1'b0;
				
				//internals
				load_cnt <= 0;
				datawr_cnt <= 0;
				datard_cnt <= 0;
				
				//state
				if (en==1'b1) begin 			//enable can be a single clk cycle high trigger 
					state <= STATE_SHIFT;
					sload <= 1'b0;				//load low starts the transfer, this makes sure the first bit is clocked in correctly
				end else begin
					state <= STATE_IDLE;
				end
			end
			
			
			
			STATE_SHIFT : begin
				//outputs
				swr <= 1'b1;
				datareadback <= 63'b0;
				sload <= 1'b0;					//load low starts the transfer
				sreset <= 1'b0;
				
				//internals
				load_cnt <= 0;
				datard_cnt <= 0;
				datawr_cnt <= datawr_cnt + 1;
				
				//state
				if(datawr_cnt >= (NDATA-1)) begin
					state <= STATE_LOAD;
					sload <= 1'b1;				//load high ends the transfer
					datawr_cnt <= 0;
					datard_cnt <= 0;
				end else begin
					state <= STATE_SHIFT;
				end
			end
			
			
			STATE_LOAD : begin
				//outputs
				swr <= 1'b1;
				datareadback <= 63'b0;
				sload <= 1'b1;					//assert load to finish the transfer, this also allows readback of data
				sreset <= 1'b0;
				
				//internals
				datawr_cnt <= 0;	//reset otherwise 'U'
				datard_cnt <= 0;
				load_cnt <= load_cnt + 1;
				
				//state			
				if(load_cnt >= LOAD_WAIT) begin
					state <= STATE_LOAD_TRANSFER;
					load_cnt <= 0;
				end else begin	
					state <= STATE_LOAD;
				end			
			end
					
			
			STATE_LOAD_TRANSFER : begin
				//outputs
				sload <= 1'b1; 						//load always high until transfer initiates
				sreset <= 1'b0;
				datareadback <= 63'b0;				
				swr <= 1'b0;							//preset WR = 0, transfers data into readback shift register
				
				//internals
				datard_cnt <= 0;
				datawr_cnt <= 0;						//reset the counter
				load_cnt <= load_cnt + 1;
				
				//state			
				if(load_cnt >= LOAD_WAIT) begin
					state <= STATE_SHIFT_READ;
					sload <= 1'b0;				//load low starts the transfer, this makes sure the first bit is clocked in correctly
				end else begin	
					state <= STATE_LOAD_TRANSFER;
				end
			end
			
			
			STATE_SHIFT_READ : begin
				//outputs
				sload <= 1'b0;	 		//load goes low initiating transfer
				sreset <= 1'b0;
				swr <= 1'b0;
				
				//internals
				datawr_cnt <= datawr_cnt + 1;			//keep on transfering, otherwise it will reset to a constant value on SDIN
				datard_cnt <= datard_cnt + 1;
				
//				datareadback[datard_cnt] <= sdout;  //this has to be here because it throws a compilation error otherwise
				datareadback[NDATA-1-datard_cnt] <= sdout;  //this has to be here because it throws a compilation error otherwise
				
				//state
				if(datard_cnt >= (NDATA-1)) begin
					state <= STATE_IDLE;
					sload <= 1'b1;				//load high ends the transfer
					datawr_cnt <= 0;
					datard_cnt <= 0;
				end else begin
					state <= STATE_SHIFT_READ;
				end
			end

			
			default: begin
				//outputs
				swr <= 1'b1;
				datareadback <= 63'b0;
				sload <= 1'b1;
				sreset <=1'b1;
				
				//internals
				load_cnt <= 0;
				datawr_cnt <= 0;
				datard_cnt <= 0;
				
				//state
				state <= STATE_IDLE;
			end	
			
		endcase
	end
end
endmodule

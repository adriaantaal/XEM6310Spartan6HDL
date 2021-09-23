`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:01:51 08/12/2018 
// Design Name: 
// Module Name:    SPI_write 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
//AT changes to make it work with 0107_SPI_00_MOM5_phy.v
//Removed SCLK and ce_SCLK to always be on (dont gate the clock)
//
//
//
//
//

//Some other notes:

//FPGA is master, chip is slave

//SDOUT == MISO
//SDIN == MOSI

module SPI_write_at (
en,
masterdata,
clk,
rst,
swr,
sdin,
sdout,
sload,
sreset,
datareadback
);

parameter NDATA = 48;
parameter STATE_IDLE = 0;
parameter STATE_SHIFT = 1;
parameter STATE_LOAD = 2;
parameter STATE_SHIFT_READ = 3;

parameter LOAD_WAIT = 3'b100;

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
assign sdin = masterdata[datawr_cnt]; //check this line
reg [2:0] load_cnt;

always @ (posedge (clk) or posedge (rst)) begin
	if(rst) begin
		swr <= 1'b1;
		load_cnt <= 0;
		datawr_cnt <= 0;
		datard_cnt <= 0;
		state <= STATE_IDLE;
		sload <= 1'b0;
		sreset <= 1'b1;
		datareadback <= 63'b0;
	end
	else begin
		sreset <= 1'b0;
		case (state)
			STATE_IDLE : begin
				swr <= 1'b1;
				load_cnt <= 0;
				datawr_cnt <= 0;
				datard_cnt <= 0;
				sload <= 1'b0;
				if (en==1'b1) begin
					state <= STATE_SHIFT;
				end else begin
					state <= STATE_IDLE;
				end
			end
			
			
			STATE_SHIFT : begin
				swr <= 1'b1;
				datareadback <= 63'b0;
				sload <= 1'b0;				
				datard_cnt <= 0;
				if(datawr_cnt >= (NDATA-1)) begin
					state <= STATE_LOAD;
				end else begin
					datawr_cnt <= datawr_cnt + 1;
				end
			end
			
			
			STATE_LOAD : begin
				swr <= 1'b1;
				datard_cnt <= 0;
				datareadback <= 63'b0;
				if(load_cnt >= LOAD_WAIT) begin
					state <= STATE_SHIFT_READ;
					load_cnt <= 0;
					sload <= 1'b0;
				end else begin
					load_cnt <= load_cnt + 1;
					sload <= 1'b1;
				end			
			end
			
			
			STATE_SHIFT_READ : begin
				swr <= 1'b0;
				datareadback <= datareadback <<1;
				datareadback[0] <= sdout;
				if(datard_cnt >= (NDATA-1)) begin
					state <= STATE_IDLE;
				end else begin
					datard_cnt <= datard_cnt + 1;
				end
			end

			
			default: begin
				swr <= 1'b1;
				datareadback <= 63'b0;
				load_cnt <= 0;
				datawr_cnt <= 0;
				datard_cnt <= 0;
				sload <= 1'b0;
				state <= STATE_IDLE;
			end	
			
		endcase
		
	end
end
endmodule

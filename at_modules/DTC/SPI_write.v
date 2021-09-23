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
module SPI_write (
en,
epwire,
clk,
rst,
swr,
sdout,
sclk,
sload,
sreset
);

parameter NDATA = 48;
parameter STATE_IDLE = 0;
parameter STATE_SHIFT = 1;
parameter STATE_LOAD = 2;
parameter STATE_DONE = 3;

input en;
input [63:0] epwire;
input clk;
input rst;
output swr;
output reg sdout;
output reg sclk;
output reg sload;
output reg sreset;

reg en_old;
reg [6:0] state_cnt;
reg [2:0] state;
assign swr = 1;

always @ (posedge (clk) or posedge (rst)) begin
	if(rst) begin
		state_cnt <= 1'b0;
		state <= STATE_IDLE;
		sdout <= 1'b0;
		sclk <= 1'b0;
		sload <= 1'b0;
		en_old <= 1'b0;
		sreset <= 1'b1;
	end
	else begin
		sreset <= 1'b0;
		case (state)
			STATE_IDLE : 
			begin
				
				if((en==1) && (en_old==0))
				begin
					state <= STATE_SHIFT;
					state_cnt <= 0;
					sdout <= 0;
					sclk <= 0;
					sload <= 0;
					sdout <= epwire[0];
				end
			end
			STATE_SHIFT :
			begin
				if(state_cnt > NDATA)
				begin
					state <= STATE_LOAD;
					state_cnt <= 0;
					sdout <= 0;
					sclk <= 0;
					sload <= 0;				
				end
				else
					if(sclk == 1)
					begin
						sclk <= 0;
						sdout <= epwire[state_cnt];
					end
					else
					begin
						state_cnt <= state_cnt + 1;
						sclk <= 1;						
					end
				begin
				end				
			end
			STATE_LOAD :
			begin
				if(state_cnt==0)
				begin	
					sload <= 1;
					sclk <= 0;
					state_cnt <= 1;
				end
				else if (state_cnt==1)
				begin	
					sload <= 1;
					sclk <= 1;
					state_cnt <= 2;
				end
				else if (state_cnt==2)
				begin	
					sload <= 0;
					sclk <= 0;
					state_cnt <= 3;
				end
				else
				begin	
					state <= STATE_DONE;
					sload <= 0;
					sclk <= 0;
					state_cnt <= 0;
				end
			end
			STATE_DONE :
			begin
					if(en == 0)
					begin
						state <= STATE_IDLE;
					end
			end
		endcase
		en_old <= en;
	end
end
endmodule

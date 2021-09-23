`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:57:28 08/11/2018 
// Design Name: 
// Module Name:    EProbe_control 
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


//cmd has the following structure:
//[CMD method | VLED | EN | LEDADDR]

//CMD method: 2'b : state <= IDLE;
//						2'b01 : state <= PIX_UPDATE;
//		 				2'b10 : state <= UPDATE_ALL_PIX;

//VLED: 3'b : DAC value for setting LED drive strength

//EN: 1'b : enable

//LEDADDR: 10'b : addressing for 1024 uLED

module EProbe_control_quad(
clk,
rst,
cmd,
pix,
addr,
probe,
vled,
en_led,
load,
state
);

parameter  IDLE = 2'b00;
parameter  PIX_UPDATE = 2'b01;
parameter  UPDATE_ALL_PIX = 2'b10;
parameter  FULL_ADDR = 10'b1111111111;
input clk;
input rst;
input [15:0] cmd;
output [2:1] pix;
output [6:1] addr;
output [1:0] probe;
output reg [3:1] vled;
output reg en_led;
output reg load;
output reg [1:0] state;

reg [15:0] old_cmd;
reg [9:0] ledADDR;
reg [23:0] instate_counter;

reg [9:0] intADDR;

assign probe = ledADDR[9:8];
assign addr = ledADDR[7:2];
assign pix = ledADDR[1:0];

always @(posedge clk or posedge rst) begin
	if(rst) begin
		ledADDR <= 10'b0;
		old_cmd <= 16'b0;
		state <= IDLE;
		instate_counter <= 24'b0;
	end else begin
		case (state)
			IDLE : begin
				if(old_cmd != cmd) begin
					case (cmd[15:14])
						2'b00 : state <= IDLE;
						2'b01 : state <= PIX_UPDATE;
		 				2'b10 : state <= UPDATE_ALL_PIX;
						2'b11 : state <= UPDATE_ALL_PIX;
						default :  state <= IDLE;
					endcase
				end
				instate_counter <= 0;
				load <= 1'b0;		
				intADDR <= 10'b0;	
				old_cmd <= cmd;		 
			end
			PIX_UPDATE : begin
				if(instate_counter == 0) 
				begin
					load <= 1'b0;
					ledADDR <= cmd[9:0];
					vled <= cmd[13:11];
					en_led <= cmd[10];
					instate_counter <= instate_counter + 1;
				end
				else
				begin
					load <= 1'b1;
					state <= IDLE;
				end				 
			end
			UPDATE_ALL_PIX : begin
				if(instate_counter[0] == 0) 
				begin
					load <= 1'b0;
					ledADDR <= intADDR;
					vled <= cmd[13:11];
					en_led <= cmd[10];
				end
				else
				begin
					load <= 1'b1;
					if(ledADDR >= FULL_ADDR)
					begin
						state <= IDLE;						
					end
					else
					begin
						intADDR <= intADDR + 1;
					end
				end
				instate_counter <= instate_counter + 1;			 
			end
		endcase
	end
end


endmodule

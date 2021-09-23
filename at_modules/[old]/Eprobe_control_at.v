`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: AT
//////////////////////////////////////////////////////////////////////////////////

//changes by adriaan:
	//ENLED and VLED are no longer controlled by this block, its directly set by the maincode. thats because it has to settle before LOAD triggers
	//the update is given by the opal kelly trigger, such that old_cmd check is removed
	//LOAD was not given correctly! It is a positive trigger latch, such that it should toggle with each address update
	//intADDR was removed, because changing the ADDR doesnt do anything to the chip unless LOAD is asserted
	//meaning that having 2 internal address registers just clutters
	//added a few more states to make it easier to interpret

//cmd has the following structure:
//[CMD method | - | - | LEDADDR]
//CMD method: 2'b : state <= IDLE;
//						2'b01 : state <= PIX_UPDATE;
//		 				2'b10 : state <= UPDATE_ALL_PIX;

//3'b : removed (used to be VLED =  DAC value for setting LED drive strength)
//1'b : removed (used to be EN)
//LEDADDR: 10'b : addressing for 1024 uLED

//LOAD programs not only EN_LED but also programs VLED

module EProbe_control_at(
input clk,
input rst,
input [15:0] cmd,
output [2:1] pix,
output [6:1] addr,
output [1:0] probe,
output reg load,
output reg [2:0] state,
input updatetrig
);

parameter  IDLE = 3'b000;
parameter  PIX_UPDATE_PREP = 3'b001;
parameter  PIX_UPDATE = 3'b010;
parameter  UPDATE_ALL_LOAD = 3'b011;
parameter  UPDATE_ALL_NEXT_PIX = 3'b100;
		
parameter  FULL_ADDR = 10'b1111111111;
parameter  ADDR_WAIT = 4'b1000;

reg [9:0] ledADDR;
reg [23:0] instate_counter;

assign probe = ledADDR[9:8];
assign addr = ledADDR[7:2];
assign pix = ledADDR[1:0];

always @(posedge clk or posedge rst) begin
	if(rst) begin
		ledADDR <= 10'b0;
		state <= IDLE;
		instate_counter <= 4'b0;
	end else begin
		case (state)
			IDLE : begin
				instate_counter <= 0;
				load <= 1'b0;		
				ledADDR <= 10'b0;	
				if (updatetrig == 1'b1) begin
					case (cmd[15:14])
						2'b00 : state <= IDLE;
						2'b01 : state <= PIX_UPDATE_PREP;
						2'b10 : state <= UPDATE_ALL_LOAD;
						2'b11 : state <= UPDATE_ALL_LOAD;
						default :  state <= IDLE;
					endcase
				end
			end
						
			PIX_UPDATE_PREP : begin
				load <= 1'b0;
				ledADDR <= cmd[9:0];
				instate_counter <= instate_counter + 1;
				if(instate_counter >= ADDR_WAIT) begin //when # of windows is reached
					state <= PIX_UPDATE;
				end else begin
					state <= PIX_UPDATE_PREP;
				end
			end
			
			
			PIX_UPDATE : begin 
				instate_counter <= 4'b0;
				ledADDR <= cmd[9:0];
				load <= 1'b1;
				state <= IDLE;
			end
			
			
			UPDATE_ALL_LOAD : begin				
				load <= 1'b1; //assert LOAD, AS VLED, ADDR and ENLED have already been settled
				if(ledADDR >= FULL_ADDR) begin //when # of windows is reached
					state <= IDLE;
				end else begin
					state <= UPDATE_ALL_NEXT_PIX;
				end
				
			end
			
			
			UPDATE_ALL_NEXT_PIX : begin				
				load <= 1'b0; //deassert LOAD to have it toggle on next cycle
				ledADDR <= ledADDR + 1;
				state <= UPDATE_ALL_LOAD;
//				if(instate_counter >= ADDR_WAIT) begin //when # of windows is reached
//					state <= UPDATE_ALL_LOAD;
//				end else begin
//					state <= UPDATE_ALL_NEXT_PIX;
//				end	
			end
			
			
			
			default: begin //same behaviour as reset clause
				instate_counter <= 4'b0;
				ledADDR <= cmd[9:0];
				load <= 1'b0;
				state <= IDLE;
			end
		endcase
	end
end

endmodule

`timescale 1ns / 1ps

// purpose: after spi_master has entered all values, control global shutter for LEDs
// inputs: rst, en, clk, on_win, off_win
// outputs: led_on




module clkdivcounter_v1(
	//from FPGA
	rst, //reset
	en, //enable
	clk, //100MHz clock
	t_high, //number of clock periods for shutter high
	t_low, //number of clock periods for shutter low
	
	//to IC
	clkout
);

//input
input wire rst;
input wire en;
input wire clk;
input wire [31:0] t_high;
input wire [31:0] t_low;

//output
output reg clkout;

//internals
reg [31:0] cnt_high;
reg [31:0] cnt_low;

//state internal
reg [1:0] state;

//states
parameter IDLE = 2'b00;
parameter HIGH = 2'b01;
parameter LOW = 2'b10;



//sequential logic
always @(posedge clk or posedge rst) begin
	if(rst) begin
		clkout <= 1'b0;
		cnt_high <= 32'b0;
		cnt_low <= 32'b0;
		state <= IDLE;
	end else begin
		case(state)
			IDLE: begin
				clkout <= 1'b0;
				cnt_high	<= 32'b0;
				cnt_low	<= 32'b0;
				if(en) begin
					state <= HIGH;
				end
			end
		
			HIGH: begin
				clkout <= 1'b1;
				cnt_low	<= 32'b0;
				if(en) begin
					if(cnt_high >= t_high) begin
						cnt_high <= 32'b0;
						state <= LOW;
					end else begin
						cnt_high	<= cnt_high + 1'b1;
						state <= HIGH;
					end
				end else begin
					cnt_high <= 32'b0;
					state <= IDLE;
				end
			end
				
			LOW: begin
				clkout <= 1'b0;
				cnt_high	<= 32'b0;
				if(en) begin			
					if(cnt_low >= t_low) begin
						cnt_low <= 32'b0;
						state <= HIGH;
					end else begin
						cnt_low	<= cnt_low + 1'b1;
						state <= LOW;
					end
				end else begin
					cnt_low <= 32'b0;
					state <= IDLE;
				end
			end
						
			default: begin //same behaviour as reset clause
				clkout <= 1'b0;
				cnt_high	<= 32'b0;
				cnt_low	<= 32'b0;
				state <= IDLE;
			end
		endcase
	end
end

endmodule

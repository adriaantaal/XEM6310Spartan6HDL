//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:25:36 08/26/2017 
// Design Name: 
// Module Name:    Pixel_emulate_v1 
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
module SPAD_chip_emul_photon(
    input PHOTON,
    input [7:0] ADDRESS, //256 pixels total
    input MEM_CLEAR, //clear 5bit spad count, over all pixels
    input PIX_OFF, //pix
    input READ, //when high, DOUT = data; when low, DOUT = 5'b00000
    input RETIME, //clock. 100MHz?
    input RSTB, //when low, clear list of hot pixels to ignore. All pixels become active.
    input SPAD_ON, //external spad_count enable signal. width and PLL delay is externally set.
    output [4:0] DOUT //5bit spad count
    );

reg [255:0] hot_pixel;
reg [4:0] counter[255:0];
wire [4:0] short_add;
wire [4:0] meta_data;
reg [9:0] ii;

// When retime comes in	 
always @(posedge RETIME or negedge RSTB)
begin
// Async hot-pixel storage reset
	if(RSTB == 0) begin
		hot_pixel = 0; //set all 256 bits to zero
	end else if (PIX_OFF ==1) begin
		hot_pixel[ADDRESS] = 1;
	end
end

// Emulate data clear && fake data out by counter
always @(posedge PHOTON or posedge MEM_CLEAR)
begin
	for (ii=0; ii<255; ii=ii+1) begin
		if(MEM_CLEAR == 1) begin
			counter[ii] = 0;
		end else if (hot_pixel[ii]) begin
//			counter[ADDRESS] = 0;
		end else if (counter[ii] < 31 && SPAD_ON==1) begin
			counter[ii] = counter[ii]+1;
		end
	end
end

assign short_add = ADDRESS[4:0];
assign meta_data = (short_add>counter[ADDRESS]) ? counter[ADDRESS]:short_add;
assign DOUT = (READ) ? meta_data:5'b00000; 

endmodule


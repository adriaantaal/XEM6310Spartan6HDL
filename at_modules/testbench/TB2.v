`timescale 1ns / 1ps
`include "SPAD_chip_emul_photon.v"
`include "FSM01_SINGLEPIXREAD.v"

module TB();
	// Inputs to SPAD_chip_emul
	wire [7:0] ADDRESS;
	reg PIX_OFF;
	wire READ;
	reg RETIME;
	reg RSTB;
	wire SPAD_ON;
	wire  MEM_CLEAR;

	//internal registers
	reg [7:0] readaddress;
	reg en;
	reg clk;
	reg rst;
	reg photon;
	wire req_fifowr;

	// Outputs
	wire [4:0] SPADCOUNT;
	wire [31:0] spadcountsum;



	// Instantiate the Unit Under Test (UUT)
	SPAD_chip_emul_photon SPAD_chip_emul_photon_U0 (
		.PHOTON(photon),
		.ADDRESS(ADDRESS), 
		.MEM_CLEAR(MEM_CLEAR), 
		.PIX_OFF(PIX_OFF), 
		.READ(READ), 
		.RETIME(RETIME), 
		.RSTB(RSTB), 
		.SPAD_ON(SPAD_ON), 
		.DOUT(SPADCOUNT)
	);

	FSM01_SINGLEPIXREAD FSM01_SINGLEPIXREAD_U1(
		.ADDRESS(ADDRESS),
		.MEM_CLEAR(MEM_CLEAR),
		.READ(READ),
		.SPAD_ON(SPAD_ON),
		.DIN(SPADCOUNT),
		.readaddress(readaddress),
		.en(en),
		.clk(clk),
		.rst(rst),
		.dout(spadcountsum),
		.req_fifowr(req_fifowr)
	);

	initial begin
		// Initialize Inputs
		photon = 0;
		readaddress = 22;
		PIX_OFF = 0;
		RETIME = 0;
		RSTB = 0;
		rst = 0;
		clk = 0;
		// Wait 100 ns for global reset to finish
		#100 en = 1;
		#10 RSTB = 1;
	end
always #10 clk = ~clk;
always #200 photon=~photon;
      
endmodule



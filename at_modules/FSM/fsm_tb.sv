`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:58:36 06/26/2018 
// Design Name: 
// Module Name:    FSM_v5_TB 
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

//inputs are changed to logic var  
//a bundle called interface is created to demonstrate functionality 

interface theaddr;
    wire PROBE_SEL; 
    wire [5:0] ADDR; 
    wire [2:0] PIX_SEL;
endinterface: theaddr


module fsm_tb;
//input from IC
var logic [4:0] DIN;					//data from IC

theaddr myaddr();
//output to IC
//wire PROBE_SEL; 			//1b
//wire [5:0] ADDR; 				//6b
//wire [1:0] PIX_SEL; 			//2b

wire MEM_CLEAR;			//global IC reset
wire READ_EN;				//request to IC to update data
wire SPAD_ON_CLK_EN;	//enable the laser synchronous delayed photon gathering time

//output to FPGA
wire [15:0] dout;				//16bit output to fifo; [9 address bits][00][5-bit data] 
wire req_fifowr;		//fifo write enable

//input from FPGA

var logic spad_on_clk;	//20MHz from PLL
var logic pll_locked;		//locked signal; dont open spad_on unless its locked
var logic [1:0] window_cycles;	//number of laser_clk windows to gather photons
var logic en;				//fsm enable
var logic clk;				//80 MHz clock, resolves to Tclk/2 pixel readout speed
var logic rst;				//reset


 	 	 
spadfsm myfsm(
 	
	.DIN(DIN),					//data from IC

    .spadaddr(myaddr),
//	.PROBE_SEL(PROBE_SEL), 			//1b
//	.ADDR(ADDR), 				//6b
//	.PIX_SEL(PIX_SEL), 			//2b
	
	
	
	.MEM_CLEAR(MEM_CLEAR),			//global IC reset
	.READ_EN(READ_EN),				//request to IC to update data
	.SPAD_ON_CLK_EN(SPAD_ON_CLK_EN),	//enable the laser synchronous delayed photon gathering time
	
	.dout(dout),				//16bit output to fifo, [9 address bits][00][5-bit data] 
	.req_fifowr(req_fifowr),		//fifo write enable
	
	//from FPGA
	.spad_on_clk(spad_on_clk),	//20MHz from PLL
	.pll_locked(pll_locked),		//locked signal, dont open spad_on unless its locked
	.window_cycles(window_cycles),	//number of laser_clk windows to gather photons
	.en(en),				//fsm enable
	.clk(clk),				//80 MHz clock, resolves to Tclk/2 pixel readout speed
	.rst(rst)				//reset	
);


initial begin
	   //$display($time, "<< Starting the Simulation >>");
		//define inputs
        spad_on_clk			= 1'b0;		// at time 0
		DIN		= 5'b0;              
		pll_locked			= 1'b0;              
		window_cycles				= 2'b10;
		en				= 4'b0001;
		clk		= 1'b1;
		rst	= 1'b1;              
				
		//load the code  into the register and read the output
		#40 pll_locked		= 1'b1;         	// 
		en 		= 1'b1;         	// 
		rst 		= 1'b0;         	// 
		DIN 		= 5'b10011;         	// 	 	
	 end

always #50 spad_on_clk = ~spad_on_clk;		//clock period is 50ns
always #10 clk = ~clk;		//clock period is 10ns

endmodule

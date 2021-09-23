`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Columbia U
// Engineer: Adriaan Taal
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
//		v2 - [jaebin] State machine first attempt
//		v3 - [adriaan] Fixed errors, verified and made synthesizable. Moved the counter to toplevel.
//		v4 - [adriaan] added the hot pixel masking, and the LOAD signal
//		v5 - [adriaan] made the data_wait counter programmable
//		v6 - [adriaan] added extra data bit for Nov2018 tapeout
//							added dis_led and LED_ON_CLK_EN
//		v7 - [adriaan] added alternating recording phase for shared counter
//							Requires full readout cycle for BETA =0 and BETA=1	
//							Correctly asserted LOAD when the addressing has settled
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


module FSM_v7_quad(
	//out to IC
	pix_off, 			//1b
	dis_led, 			//1b
	PROBE_SEL, 			//2b
	ADDR, 				//6b
	SIDE,		 			//1b
	BETA,		 			//1b
	MEM_CLEAR,			//global IC reset
	READ_EN,				//request to IC to update data
	SPAD_ON_CLK_EN,	//enable the laser synchronous delayed photon gathering time
	LED_ON_CLK_EN,		//enable the laser synchronous led emission time gate
	DIN,					//data from IC 
	LOAD,					//enable for the pix_off and dis_led
	
	//from FPGA
	pix_off_mask,	//1024 bit hot pixel mask
	dis_led_mask,	//1024 bit defective LED mask
	spad_on_clk,	//20MHz from PLL
	pll_locked,		//locked signal, dont count the
	shutter_periods,	//number of laser_clk windows to gather photons
	delay,			//--not implemented--
	delay_cycles,	//--not implemented--
	data_wait_cycles, //
	en,				//fsm enable
	clk,				//80 MHz clock, resolves to Tclk/2 pixel readout speed
	rst,				//reset
	dout,				//16bit output to fifo, [9 address bits][00][5-bit data] 
	req_fifowr		//fifo write enable
);

//output
output wire [1:0] PROBE_SEL;
output wire [5:0] ADDR;
output wire SIDE;
output wire BETA;

output wire pix_off;
output wire dis_led;

output reg [15:0] dout;
output reg req_fifowr;
output reg READ_EN;
output reg MEM_CLEAR;
output reg SPAD_ON_CLK_EN; 
output reg LED_ON_CLK_EN; 
output reg LOAD;

//input
input wire [1023:0] pix_off_mask;
input wire [1023:0] dis_led_mask;
input wire [5:0] DIN;
input wire en;
input wire clk;
input wire rst;
input wire delay;
input wire [31:0] shutter_periods;
input wire [31:0] delay_cycles;
input wire [3:0] data_wait_cycles;
input wire spad_on_clk;
input wire pll_locked;

//states
parameter IDLE = 3'b000;
parameter CLEAR = 3'b001;
parameter RECORD = 3'b010;
parameter READ_PIX = 3'b011;
parameter NEXT_PIX_AND_FIFO = 3'b100;

//internals
reg [31:0] windows_cnt;
reg [8:0] readfromADDR;
reg BETA_int;

//state internal
reg [2:0] state;
reg [3:0] dataInCounter;

//concurrent logic
assign PROBE_SEL = readfromADDR[8:7];
assign ADDR = readfromADDR[6:1];
assign SIDE = readfromADDR[0];
assign BETA = BETA_int;
assign dis_led = dis_led_mask[{readfromADDR, BETA_int}];
assign pix_off = pix_off_mask[{readfromADDR, BETA_int}];

//needs to be done this way, otherwise it tosses a bunch of obscure errors
//always @* begin
	//set pix_off
//	pix_off = pix_off_mask[{readfromADDR, BETA_int}];
	//set dis_led
//	dis_led = dis_led_mask[{readfromADDR, BETA_int}];
//end

//sequential logic
always @(posedge clk or posedge rst) begin
	if(rst) begin
		//outputs
		dout <= 16'b0;
		req_fifowr	<= 1'b0;
		READ_EN		<= 1'b0;
		SPAD_ON_CLK_EN <= 1'b0;
		LED_ON_CLK_EN <= 1'b0;
		MEM_CLEAR 	<= 1'b0;
		LOAD 			<= 1'b0;
		//internals
		readfromADDR <= 9'b0;
		BETA_int <= 1'b0;
		//state
		state <= IDLE;
		dataInCounter <= 4'b0;
	end
	
	else begin
	
		case(state)
			IDLE: begin	//idle, this is returning state for BETA <= 0
				dout 				<= 16'b0;
				req_fifowr 		<= 1'b0;
				READ_EN 			<= 1'b1;
				SPAD_ON_CLK_EN <= 1'b0;
				LED_ON_CLK_EN 	<= 1'b0;
				MEM_CLEAR 		<= 1'b1;			//assert mem_clear 
				LOAD 			<= 1'b0;
				
				//internals
				readfromADDR	<= 9'b0;
				BETA_int 		<= 1'b0;
				
				//state
				if(en) begin
					state <= CLEAR;
				end
			end
		
			CLEAR: begin //clear mem, this is returning state for BETA <= 1
				dout <= 16'b0;
				req_fifowr <= 1'b0;
				READ_EN <= 1'b1; 
				SPAD_ON_CLK_EN <= 1'b0;
				LED_ON_CLK_EN <= 1'b0;
				MEM_CLEAR <= 1'b1;			//assert mem_clear
				LOAD 			<= 1'b0;
				//internals
				readfromADDR	<= 9'b0;
				//BETA_int is latched
				
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
				LED_ON_CLK_EN <= 1'b1; 		//enable the LED_ON from PLL to the GPIO
				MEM_CLEAR <= 1'b0;			//deassert mem_clear
				LOAD 			<= 1'b0;
				//internals				
				readfromADDR <= 9'b0;
				//BETA_int is latched
				
				if((windows_cnt >= shutter_periods)) begin //when # of windows is reached
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
				LED_ON_CLK_EN <= 1'b0;
				MEM_CLEAR <= 1'b0;
				req_fifowr <= 1'b0; 							//data should not be send to fifo
				READ_EN <= 1'b1;								//send read request to the IC	
				LOAD <= 1'b1;									//Assert LOAD to flash DIS_LED and PIX_OFF, has 1 clock cycle to settle ADDR
				
				//internals
				//readfromADDR <= is latched from the previous state
				//BETA_int is latched
															
				//set wait counter for state change to give it 8x as many clock cylces to read out the data
				if (dataInCounter >= data_wait_cycles) begin
					dout <= {readfromADDR, BETA_int , DIN}; //Even though readfromADDR is 9 bits instantiated for compatibility, only 9 are functional
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
				LED_ON_CLK_EN <= 1'b0;
				MEM_CLEAR <= 1'b0;
				READ_EN <= 1'b1;
				//dout <= is latched from the previous state
				req_fifowr <= 1'b1; 	//send it bro!!
				LOAD <= 1'b0;
				
				//internals
				//BETA_int is latched
				
				//state
				if((readfromADDR >= 9'd511) && (BETA_int == 1'b1)) begin //when the final address is surpassed. The READ_PIX state needs still be reached for pixel 511
					BETA_int <= 1'b0;
					state <= IDLE;
					readfromADDR <= 9'b0;
				end else if((readfromADDR >= 9'd511) && (BETA_int == 1'b0)) begin //reached final address (511), cycle once more for beta = 1
					BETA_int <= 1'b1;
					state <= CLEAR;
					readfromADDR <= 9'b0;
				end else begin
					state <= READ_PIX;
					readfromADDR <= readfromADDR + 1'b1; //send new address to the IC to settle for new data request
				end
			end
						
						
			default: begin //same behaviour as reset clause
				//outputs
				dout <= 16'b0;
				req_fifowr	<= 1'b0;
				READ_EN		<= 1'b0;
				SPAD_ON_CLK_EN <= 1'b0;
				LED_ON_CLK_EN <= 1'b0;
				MEM_CLEAR 	<= 1'b0;
				LOAD <= 1'b0;
				//internals
				readfromADDR <= 9'b0;
				BETA_int <= 1'b0;
				//state
				state <= IDLE;
				dataInCounter <= 4'b0;		
			end
			
		endcase
	end
end

//counter for the number of windows that have been
//because SPAD_ON_CLK and LED_ON_CLK are synchronous, we just count on SPAD_ON_CLK
always @(negedge spad_on_clk) begin
	if ((state == RECORD) && (pll_locked == 1'b1)) begin
		windows_cnt <= windows_cnt + 1;
	end else begin
		windows_cnt <= 32'b0;
	end
end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Columbia University
// Engineer: Adriaan Taal
// 
// Create Date:    16:31:26 08/11/2014 
// Design Name:    DATAPATH 
// Module Name:    mcbcontroller 
// Project Name: 	
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - Base code by Opal Kelly
// Revision 1.0 Rewritten by adriaan taal to separate the read, write and command states
//					 1.1 Correct usage of the signals p0_rd_empty and p0_wr_full
//					 1.2 Implemented fifo empty, full and valid flags
//					 
//////////////////////////////////////////////////////////////////////////////////
module at_mcbController
#(BURST_LEN = 8,
	FIFO_SIZE = 2047,
	P0_WR_SIZE = 63)(
	input wire clk,
	input wire reset,
	input wire writes_en,
	input wire reads_en,
	input wire calib_done,
	
	//from logic FIFO
	output reg inputBufferReadEnable,
	input wire [127:0] inputBufferData,
	input wire [6:0] inputBufferCount,
	input wire inputBufferValid,
	input wire inputBufferEmpty,
	
	//to logic FIFO
	output reg outputBufferWriteEnable,
	output reg [127:0] outputBufferData,
	input wire [6:0] outputBufferCount,
	input wire outputBufferFull,
	
	//RAM Usage
	output reg [26:0] memoryCount,
	output wire [3:0] mcbstate,
	
	//DRAM read state machine signals
	output reg p0_rd_en,
	input wire p0_rd_empty,
	input wire [127:0] p0_rd_data,
	
	//DRAM write state machine signals	
	input wire p0_wr_empty,
	input wire p0_wr_full,
	input wire [6:0] p0_wr_count,
	input wire p0_wr_underrun, //debug signal, connect to trigger
	output reg p0_wr_en,
	output reg [127:0] p0_wr_data,
	output wire [15:0] p0_wr_mask,
	
	//DRAM command state machine signals	
	input wire p0_cmd_full,
	output reg p0_cmd_en,
	output reg [2:0] p0_cmd_instr,
	output reg [29:0] p0_cmd_byte_addr,
	output wire [5:0] p0_cmd_bl   //bl stands for burst length
	
);

reg [29:0] cmdByteAddressWrite, cmdByteAddressRead; //Read and write address locations
reg [5:0] burstCount;
reg writeMode;
reg readMode;
reg resetD;

assign mcbstate = state;
assign p0_cmd_bl = BURST_LEN - 1;
assign p0_wr_mask = 16'h0; //always write all data to the RAM

always @(posedge clk) begin
	writeMode <= writes_en;
	readMode <= reads_en;
	resetD <= reset;
end

// FSM states
reg [3:0] state;
localparam stateIdle = 4'b0000;

localparam stateWrite0 = 4'b0001;
localparam stateWrite1 = 4'b0010;
localparam stateWrite2 = 4'b0011;

localparam stateWriteCmd0 = 4'b1000;
localparam stateWriteCmd1 = 4'b1001;
localparam stateReadCmd0 = 4'b1010;
localparam stateReadCmd1 = 4'b1011;

localparam stateRead0 = 4'b1100;
localparam stateRead1 = 4'b1101;
localparam stateRead2 = 4'b1110;
localparam stateRead3 = 4'b1111;

// synchronous FSM advancement, with sync reset
always @(posedge clk) begin

	if (resetD == 1'b1) begin
			
		//internally latched signals
		burstCount <= BURST_LEN;
		cmdByteAddressWrite <= 30'd0;
		cmdByteAddressRead <= 30'd0;
		memoryCount <= 28'd0;
		p0_cmd_byte_addr <= 30'd0;
		
		//state
		state <= stateIdle;
			
		//Control signals, have to be timed well
		p0_cmd_instr <= 3'd0;
		p0_cmd_en <= 1'b0;
		p0_wr_en <= 1'b0;
		p0_rd_en <= 1'b0;
		inputBufferReadEnable <= 1'b0;
		outputBufferWriteEnable <= 1'b0;
		
	end else begin
						
      case (state)
         stateIdle: begin
					p0_cmd_en <= 1'b0; //Disable the commands!
					p0_wr_en <= 1'b0;	
					p0_rd_en <= 1'b0;
					inputBufferReadEnable <= 1'b0;
					outputBufferWriteEnable <= 1'b0;
					burstCount <= BURST_LEN;	
					
					//prefer writing to the RAM over reading, so as to never bottleneck the IC connection
					//Has to have enough data in the FIFO
					//Cannot write to a read address, but can read from a write address [&& (cmdByteAddressWrite != cmdByteAddressRead)]
					//RAM write to FIFO not be full
					//Memory write buffer needs enough space && (p0_wr_count <=(P0_WR_SIZE-BURST_LEN)) 
					//Memory needs enough space
					
					
					if ( (p0_cmd_full == 1'b0)  && (inputBufferEmpty == 1'b0)  &&(p0_wr_full == 1'b0) && (calib_done == 1'b1) && (writeMode == 1'b1) && (inputBufferCount >= BURST_LEN) && (memoryCount < 28'h7FFFFFF - BURST_LEN*16)) begin
						state <= stateWrite0;
					end
					
					//FIFO not full (this signal is faster than the count)
					//FIFO has to have enough space
					//Memory has to have enough data
					//RAM FIFO should be empty! -> ignore for now
					else if ((p0_cmd_full == 1'b0) && (calib_done == 1'b1) && (readMode == 1'b1) && (outputBufferFull == 1'b0) && (outputBufferCount <= (FIFO_SIZE - BURST_LEN)) && (memoryCount > BURST_LEN*16)) begin
						state <= stateReadCmd0;
					end
         end
			
			//WRITE goes in the following order
				//0. Enable read data from the fifo
				//1. Update p0_wr_data from the fifo, decrease burst count
				//2. Give the write enable to the RAM
				//   Update the memory count
				//   update the write address
			
			stateWrite0: begin
					p0_wr_en <= 1'b0;					 //disable sending the data
					inputBufferReadEnable <= 1'b1; //request fifo write enable
					state <= stateWrite1;
			end
			
			stateWrite1: begin
					inputBufferReadEnable <= 1'b0;		//disable fifo write request again
					if (inputBufferValid == 1'b1) begin
						p0_wr_data <= inputBufferData;	//capture the data
						burstCount <= burstCount - 1;		//update the burst count to compare next cycle
						state <= stateWrite2;
					end
			end
			
			
			stateWrite2: begin
			if (p0_wr_full == 1'b0)  begin
					p0_wr_en <= 1'b1;						//send the data to the FIFO
					if ((burstCount ==  6'd0)) begin
						state <= stateWriteCmd0;
						memoryCount <= memoryCount + 16*BURST_LEN; //add 16 bytes * burst len written to the RAM (128b)
						cmdByteAddressWrite	<= {cmdByteAddressWrite + 16*BURST_LEN}[29:0]; //increment the address with 16 bytes to prepare for command cycle
					end else begin
						state <= stateWrite0;
					end
				end
			end
			
			//Command state machine is as follows
				//w0: load the instruction and the address
				//w1: execute and return
				
			stateWriteCmd0: begin
					p0_wr_en <= 1'b0;					 	//disable sending the data
					p0_cmd_instr <= 3'b000;				//000 is the write instruction
					p0_cmd_byte_addr <= cmdByteAddressWrite; //update the command register with the last WRITE address
					state <= stateWriteCmd1;					
			end
			
			stateWriteCmd1: begin
					p0_cmd_en <= 1'b1;					//enable the command to write
					state <= stateIdle;					//return to base
			end
			
			//Command read state machine is as follows
				//r0: load the instruction and the address
				//r1: execute and start readout
			
			stateReadCmd0: begin
					p0_cmd_instr <= 3'b001;						 	//001 is the read instruction
					p0_cmd_byte_addr <= cmdByteAddressRead; 	//update the command register with the last READ address
					state <= stateReadCmd1;					
			end
			
			stateReadCmd1: begin
					p0_cmd_en <= 1'b1;					//enable the command to read
					state <= stateRead0;					//return to read statemachine
			end
			
			//READ goes in the following order
				//0. If data, Enable read data from the RAM fifo
				//1. Capture the data
				//2. Pass the data to the FIFO, decrease burst count
				//   
				//   
			
			stateRead0: begin
					p0_cmd_en <= 1'b0;				 //disable the command
					if (p0_rd_empty==0) begin 		 //check if theres data before continuuing
						p0_rd_en  <= 1'b1;			 //enable reading from the RAM FIFO
						state <= stateRead1;
					end
			end
			
			stateRead1: begin
					outputBufferData <= p0_rd_data;		//capture the data
					p0_rd_en  <= 1'b0;					 	//disable reading from the RAM FIFO
					state <= stateRead2;
			end
			
			stateRead2: begin
					outputBufferWriteEnable <= 1'b1;		//send the data to the fifo
					burstCount <= burstCount - 1'b1;		//decrease the burstcount
					state <= stateRead3;
			end
			
			stateRead3: begin
					outputBufferWriteEnable <= 1'b0;								//disable sending to FIFO
					if ((burstCount == 6'd0)) begin 	//retrieved enough data from the FIFO
						memoryCount <= memoryCount - 16*BURST_LEN; 			//16 bytes (128b) * burst len removed from the RAM 
						cmdByteAddressRead	<= {cmdByteAddressRead + 16*BURST_LEN}[29:0]; //increment the address with 16 bytes for next cycle
						state <= stateIdle;
					end else begin
						state <= stateRead0;
					end
			end
			
		endcase
	end
end

endmodule

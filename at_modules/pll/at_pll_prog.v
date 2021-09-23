///////////////////////////////////////////////////////////////////////////////
//
// Company:          Xilinx
// Engineer:         Karl Kurbjun and Carl Ribbing
// Edited by:		 Adriaan Taal - Columbia University
// Date:             12/10/2009
// Design Name:      PLL DRP
// Module Name:      pll_drp.v
// Version:          1.1
// Target Devices:   Spartan 6 Family
// Tool versions:    L.68 (lin)
// Description:      This calls the DRP register calculation functions and
//                   provides a state machine to perform PLL reconfiguration
//                   based on the calulated values stored in a initialized ROM.
//
// Changes by Adriaan to make it fully dynamic:
//     	changed the parameters to inputs
//		removed everything that was connected to state 2
//		removed initialization of the Rom
//		the calculation (s6_pll_count_calc) outputs are now regs instead of localparams
//		removed initial begin, and replaced assigning the variable ROM in the concurrent logic
//		removed the SADDR logic and input, as there is only 1 set of variables to flash
///////////////////////////////////////////////////////////////////////////////



`timescale 1ps/1ps

//define

module at_pll_prog
	#(parameter CLKFBOUT_MULT    = 40,
      parameter CLKFBOUT_PHASE  = 0,
		parameter DIVCLK_DIVIDE   = 1)
      ( 	
      input [7:0] CLKOUT0_DIVIDE,
      input wire signed [31:0] CLKOUT0_PHASE,
      input [31:0] CLKOUT0_DUTY,
      
      input [7:0] CLKOUT1_DIVIDE,
      input signed [31:0] CLKOUT1_PHASE,
      input [31:0] CLKOUT1_DUTY,
      
      input [7:0] CLKOUT2_DIVIDE,
      input signed [31:0] CLKOUT2_PHASE,
      input [31:0] CLKOUT2_DUTY,
      
      input [7:0] CLKOUT3_DIVIDE,
      input signed [31:0] CLKOUT3_PHASE,
      input [31:0] CLKOUT3_DUTY,
      
      input [7:0] CLKOUT4_DIVIDE,
      input signed [31:0] CLKOUT4_PHASE,
      input [31:0] CLKOUT4_DUTY,
      
      input [7:0] CLKOUT5_DIVIDE,
      input signed [31:0] CLKOUT5_PHASE,
      input [31:0] CLKOUT5_DUTY,
      // These signals are controlled by user logic interface and are covered
      // in more detail within the XAPP.
      input             SEN,
      input             SCLK,
      input             RST,
      output reg        SRDY,
      
      // These signals are to be connected to the PLL_ADV by port name.
      // Their use matches the PLL port description in the Device User Guide.
      input      [15:0] DO,
      input             DRDY,
      input             LOCKED,
      output reg        DWE,
      output reg        DEN,
      output reg [4:0]  DADDR,
      output reg [15:0] DI,
      output            DCLK,
      output reg        RST_PLL
   );

   // 100 ps delay for behavioral simulations
   localparam  TCQ = 100;

	//input type declaration	
   // for ease of use, still call the saved data unit ROM 
   wire [36:0]  rom [22:0];
   reg [5:0]   rom_addr;
   reg [36:0]  rom_do;
   
   reg         next_srdy;

   reg [5:0]   next_rom_addr;
   reg [4:0]   next_daddr;
   reg         next_dwe;
   reg         next_den;
   reg         next_rst_pll;
   reg [15:0]  next_di;
   
    // Pass SCLK to DCLK for the PLL
   assign DCLK = SCLK;
   // include the PLL reconfiguration functions.  This contains the constant
   // functions that are used in the calculations below.  This file is 
   // required.
   `include "pll_drp_func.h"
   
	// take the constant ones as localparams so not to screw anything up
	localparam [22:0] CLKFBOUT 		= s6_pll_count_calc(CLKFBOUT_MULT, CLKFBOUT_PHASE , 50000);
	localparam [9:0] DIGITAL_FILT    = s6_pll_filter_lookup(CLKFBOUT_MULT, "OPTIMIZED");    
   localparam [39:0] LOCK           = s6_pll_lock_lookup(CLKFBOUT_MULT);    
	localparam [22:0] DIVCLK         = s6_pll_count_calc(DIVCLK_DIVIDE, 0, 50000);     
	
   wire [22:0] CLKOUT0;
   wire [22:0] CLKOUT1;
   wire [22:0] CLKOUT2;
   wire [22:0] CLKOUT3;
   wire [22:0] CLKOUT4;
   wire [22:0] CLKOUT5;
   //**************************************************************************
   // Calculations
   //**************************************************************************
			
   
	assign CLKOUT0        = s6_pll_count_calc(CLKOUT0_DIVIDE, CLKOUT0_PHASE, CLKOUT0_DUTY);        
   assign CLKOUT1        = s6_pll_count_calc(CLKOUT1_DIVIDE, CLKOUT1_PHASE, CLKOUT1_DUTY); 
   assign CLKOUT2        = s6_pll_count_calc(CLKOUT2_DIVIDE, CLKOUT2_PHASE, CLKOUT2_DUTY); 
   assign CLKOUT3        = s6_pll_count_calc(CLKOUT3_DIVIDE, CLKOUT3_PHASE, CLKOUT3_DUTY); 
   assign CLKOUT4        = s6_pll_count_calc(CLKOUT4_DIVIDE, CLKOUT4_PHASE, CLKOUT4_DUTY); 
   assign CLKOUT5        = s6_pll_count_calc(CLKOUT5_DIVIDE, CLKOUT5_PHASE, CLKOUT5_DUTY); 
   
	
    //***********************************************************************
    // data assignment
	 // rom entries contain (in order) the address, a bitmask, and a bitset
    //***********************************************************************
      
     assign rom[0] = {5'h05, 16'h50FF,  CLKOUT0[19], 1'b0, CLKOUT0[18], 1'b0,//bits 15 down to 12
	                              CLKOUT0[16], CLKOUT0[17], CLKOUT0[15], CLKOUT0[14], 8'h00};//bits 11 downto 0
								 
	  assign rom[1] = {5'h06, 16'h010B,  CLKOUT1[4], CLKOUT1[5], CLKOUT1[3], CLKOUT1[12], //bits 15 down to 12
	                              CLKOUT1[1], CLKOUT1[2], CLKOUT1[19], 1'b0, CLKOUT1[17], CLKOUT1[16], //bits 11 down to 6
								  CLKOUT1[14], CLKOUT1[15], 1'b0, CLKOUT0[13], 2'b00}; //bits 5 down to 0
								 
	  assign rom[2] = {5'h07, 16'hE02C,  3'b000, CLKOUT1[11], CLKOUT1[9], CLKOUT1[10], //bits 15 down to 10
	                              CLKOUT1[8], CLKOUT1[7], CLKOUT1[6], CLKOUT1[20], 1'b0, CLKOUT1[13], //bits 9 down to 4 
								  2'b00, CLKOUT1[21], CLKOUT1[22]}; //bits 3 down to 0
								 
	  assign rom[3] = {5'h08, 16'h4001,  CLKOUT2[22], 1'b0, CLKOUT2[5], CLKOUT2[21], //bits 15 downto 12
	                              CLKOUT2[12], CLKOUT2[4], CLKOUT2[3], CLKOUT2[2], CLKOUT2[0], CLKOUT2[19], //bits 11 down to 6
								  CLKOUT2[17], CLKOUT2[18], CLKOUT2[15], CLKOUT2[16], CLKOUT2[14], 1'b0}; //bits 5 down to 0
								 
	  assign rom[4] = {5'h09, 16'h0D03,  CLKOUT3[14], CLKOUT3[15], CLKOUT0[21], CLKOUT0[22], 2'b00, CLKOUT2[10], 1'b0, //bits 15 downto 8
	                              CLKOUT2[9], CLKOUT2[8], CLKOUT2[6], CLKOUT2[7], CLKOUT2[13], CLKOUT2[20], 2'b00}; //bits 7 downto 0
								 
	  assign rom[5] = {5'h0A, 16'hB001,  1'b0, CLKOUT3[13], 2'b00, CLKOUT3[21], CLKOUT3[22], CLKOUT3[5], CLKOUT3[4], //bits 15 downto 8
	                              CLKOUT3[12], CLKOUT3[2], CLKOUT3[0], CLKOUT3[1], CLKOUT3[18], CLKOUT3[19], //bits 7 downto 2
								  CLKOUT3[17], 1'b0}; //bits 1 downto 0
								  
	  assign rom[6] = {5'h0B, 16'h0110,  CLKOUT0[5], CLKOUT4[19], CLKOUT4[14], CLKOUT4[17], //bits 15 downto 12
	                              CLKOUT4[15], CLKOUT4[16], CLKOUT0[4], 1'b0, CLKOUT3[11], CLKOUT3[10], //bits 11 downto 6 
								  CLKOUT3[9], 1'b0, CLKOUT3[7], CLKOUT3[8], CLKOUT3[20], CLKOUT3[6]}; //bits 5 downto 0
								 
	  assign rom[7] = {5'h0C, 16'h0B00,  CLKOUT4[7], CLKOUT4[8], CLKOUT4[20], CLKOUT4[6], 1'b0, CLKOUT4[13], //bits 15 downto 10
	                              2'b00, CLKOUT4[22], CLKOUT4[21], CLKOUT4[4], CLKOUT4[5], CLKOUT4[3], //bits 9 downto 3
								  CLKOUT4[12], CLKOUT4[1], CLKOUT4[2]}; //bits 2 downto 0
								 
	  assign rom[8] = {5'h0D, 16'h0008,  CLKOUT5[2], CLKOUT5[3], CLKOUT5[0], CLKOUT5[1], CLKOUT5[18], //bits 15 downto 11
								  CLKOUT5[19], CLKOUT5[17], CLKOUT5[16], CLKOUT5[15], CLKOUT0[3], //bits 10 downto 6
								  CLKOUT0[0], CLKOUT0[2], 1'b0, CLKOUT4[11], CLKOUT4[9], CLKOUT4[10]}; //bits 5 downto 0
								 
	  assign rom[9] = {5'h0E, 16'h00D0,  CLKOUT5[10], CLKOUT5[11], CLKOUT5[8], CLKOUT5[9], CLKOUT5[6], //bits 15 downto 11
								  CLKOUT5[7], CLKOUT5[20], CLKOUT5[13], 2'b00, CLKOUT5[22], 1'b0, //bits 10 downto 4
								  CLKOUT5[5], CLKOUT5[21], CLKOUT5[12], CLKOUT5[4]}; //bits 3 downto 0
								 
	  assign rom[10] = {5'h0F, 16'h0003, CLKFBOUT[4], CLKFBOUT[5], CLKFBOUT[3], CLKFBOUT[12], CLKFBOUT[1], //bits 15 downto 11
	                              CLKFBOUT[2], CLKFBOUT[0], CLKFBOUT[19], CLKFBOUT[18], CLKFBOUT[17], //bits 10 downto 6
								  CLKFBOUT[15], CLKFBOUT[16], CLKOUT0[12], CLKOUT0[1], 2'b00}; //bits 5 downto 0
								  
	  assign rom[11] = {5'h10, 16'h800C, 1'b0, CLKOUT0[9], CLKOUT0[11], CLKOUT0[10], CLKFBOUT[10], CLKFBOUT[11], //bits 15 downto 10
								  CLKFBOUT[9], CLKFBOUT[8], CLKFBOUT[7], CLKFBOUT[6], CLKFBOUT[13],  //bits 9 downto 5
								  CLKFBOUT[20], 2'b00, CLKFBOUT[21], CLKFBOUT[22]}; //bits 4 downto 0
										
	  assign rom[12] = {5'h11, 16'hFC00, 6'h00, CLKOUT3[3], CLKOUT3[16], CLKOUT2[11], CLKOUT2[1], CLKOUT1[18], //bits 15 downto 6
								  CLKOUT1[0], CLKOUT0[6], CLKOUT0[20], CLKOUT0[8], CLKOUT0[7]}; //bits 5 downto 0
								  
	  assign rom[13] = {5'h12, 16'hF0FF, 4'h0, CLKOUT5[14], CLKFBOUT[14], CLKOUT4[0], CLKOUT4[18],  8'h00};  //bits 15 downto 0
								  
	  assign rom[14] = {5'h13, 16'h5120, DIVCLK[11], 1'b0, DIVCLK[10], 1'b0, DIVCLK[7], DIVCLK[8],  //bits 15 downto 10
	                              DIVCLK[0], 1'b0, DIVCLK[5], DIVCLK[2], 1'b0, DIVCLK[13], 4'h0};  //bits 9 downto 0
								  
	  assign rom[15] = {5'h14, 16'h2FFF, LOCK[1], LOCK[2], 1'b0, LOCK[0], 12'h000}; //bits 15 downto 0
								  
	  assign rom[16] = {5'h15, 16'hBFF4, 1'b0, DIVCLK[12], 10'h000, LOCK[38], 1'b0, LOCK[32], LOCK[39]}; //bits 15 downto 0								  
								  
	  assign rom[17] = {5'h16, 16'h0A55, LOCK[15], LOCK[13], LOCK[27], LOCK[16], 1'b0, LOCK[10],   //bits 15 downto 10
	                              1'b0, DIVCLK[9], DIVCLK[1], 1'b0, DIVCLK[6], 1'b0, DIVCLK[3],  //bits 9 downto 3
								  1'b0, DIVCLK[4], 1'b0};  //bits 2 downto 0
	  
	  assign rom[18] = {5'h17, 16'hFFD0, 10'h000, LOCK[17], 1'b0, LOCK[8], LOCK[9], LOCK[23], LOCK[22]}; //bits 15 downto 0	  
								  
	  assign rom[19] = {5'h18, 16'h1039, DIGITAL_FILT[6], DIGITAL_FILT[7], DIGITAL_FILT[0], 1'b0, //bits 15 downto 12
								  DIGITAL_FILT[2], DIGITAL_FILT[1], DIGITAL_FILT[3], DIGITAL_FILT[9], //bits 11 downto 8
								  DIGITAL_FILT[8], LOCK[26], 3'h0, LOCK[19], LOCK[18], 1'b0}; //bits 7 downto 0								
								  
	  assign rom[20] = {5'h19, 16'h0000, LOCK[24], LOCK[25], LOCK[21], LOCK[14], LOCK[11], //bits 15 downto 11
								  LOCK[12], LOCK[20], LOCK[6], LOCK[35], LOCK[36], //bits 10 downto 6
								  LOCK[37], LOCK[3], LOCK[33], LOCK[31], LOCK[34], LOCK[30]}; //bits 5 downto 0
								  
	  assign rom[21] = {5'h1A, 16'hFFFC, 14'h0000, LOCK[28], LOCK[29]};  //bits 15 downto 0
	  
	  assign rom[22] = {5'h1D, 16'h2FFF, LOCK[7], LOCK[4], 1'b0, LOCK[5], 12'h000};	//bits 15 downto 0
	  
   // Output the initialized rom value based on rom_addr each clock cycle
   always @(posedge SCLK) begin
      rom_do<= #TCQ rom[rom_addr];
   end
   
   //**************************************************************************
   // Everything below is associated whith the state machine that is used to
   // Read/Modify/Write to the PLL.
   //**************************************************************************

   // State sync
   reg [3:0]  current_state   = RESTART;
   reg [3:0]  next_state      = RESTART;
   
   // State Definitions
   localparam RESTART      = 4'h1;
   localparam WAIT_LOCK    = 4'h2;
   localparam WAIT_SEN     = 4'h3;
   localparam ADDRESS      = 4'h4;
   localparam WAIT_A_DRDY  = 4'h5;
   localparam BITMASK      = 4'h6;
   localparam BITSET       = 4'h7;
   localparam WRITE        = 4'h8;
   localparam WAIT_DRDY    = 4'h9;
   
   // These variables are used to keep track of the number of iterations that 
   //    each state takes to reconfigure
   // STATE_COUNT_CONST is used to reset the counters and should match the
   //    number of registers necessary to reconfigure each state.
   localparam STATE_COUNT_CONST = 23;
   reg [4:0] state_count         = STATE_COUNT_CONST; 
   reg [4:0] next_state_count    = STATE_COUNT_CONST;
   
   // This block assigns the next register value from the state machine below
   always @(posedge SCLK) begin
      DADDR       <= #TCQ next_daddr;
      DWE         <= #TCQ next_dwe;
      DEN         <= #TCQ next_den;
      RST_PLL     <= #TCQ next_rst_pll;
      DI          <= #TCQ next_di;
      
      SRDY        <= #TCQ next_srdy;
      
      rom_addr    <= #TCQ next_rom_addr;
      state_count <= #TCQ next_state_count;
   end
   
   // This block assigns the next state, reset is syncronous.
   always @(posedge SCLK) begin
      if(RST) begin
         current_state <= #TCQ RESTART;
      end else begin
         current_state <= #TCQ next_state;
      end
   end
   
   always @* begin
      // Setup the default values
      next_srdy         = 1'b0;
      next_daddr        = DADDR;
      next_dwe          = 1'b0;
      next_den          = 1'b0;
      next_rst_pll      = RST_PLL;
      next_di           = DI;
      next_rom_addr     = rom_addr;
      next_state_count  = state_count;
   
      case (current_state)
         // If RST is asserted reset the machine
         RESTART: begin
            next_daddr     = 5'h00;
            next_di        = 16'h0000;
            next_rom_addr  = 6'h00;
            next_rst_pll   = 1'b1;
            next_state     = WAIT_LOCK;
         end
         
         // Waits for the PLL to assert LOCKED - once it does asserts SRDY
         WAIT_LOCK: begin
            // Make sure reset is de-asserted
            next_rst_pll   = 1'b0;
            // Reset the number of registers left to write for the next 
            // reconfiguration event.
            next_state_count = STATE_COUNT_CONST;
            
            if(LOCKED) begin
               // PLL is locked, go on to wait for the SEN signal
               next_state  = WAIT_SEN;
               // Assert SRDY to indicate that the reconfiguration module is
               // ready
               next_srdy   = 1'b1;
            end else begin
               // Keep waiting, locked has not asserted yet
               next_state  = WAIT_LOCK;
            end
         end
         
         // Wait for the next SEN pulse and set the ROM addr appropriately 
         WAIT_SEN: begin
            if(SEN) begin
               // SEN was asserted
			   next_rom_addr = 8'h00;
               // Go on to address the PLL
               next_state = ADDRESS;
            end else begin
               // Keep waiting for SEN to be asserted
               next_state = WAIT_SEN;
            end
         end
         
         // Set the address on the PLL and assert DEN to read the value
         ADDRESS: begin
            // Reset the DCM through the reconfiguration
            next_rst_pll  = 1'b1;
            // Enable a read from the PLL and set the PLL address
            next_den       = 1'b1;
            next_daddr     = rom_do[36:32];
            
            // Wait for the data to be ready
            next_state     = WAIT_A_DRDY;
         end
         
         // Wait for DRDY to assert after addressing the PLL
         WAIT_A_DRDY: begin
            if(DRDY) begin
               // Data is ready, mask out the bits to save
               next_state = BITMASK;
            end else begin
               // Keep waiting till data is ready
               next_state = WAIT_A_DRDY;
            end
         end
         
         // Zero out the bits that are not set in the mask stored in rom
         BITMASK: begin
            // Do the mask
            next_di     = rom_do[31:16] & DO;
            // Go on to set the bits
            next_state  = BITSET;
         end
         
         // After the input is masked, OR the bits with calculated value in rom
         BITSET: begin
            // Set the bits that need to be assigned
            next_di           = rom_do[15:0] | DI;
            // Set the next address to read from ROM
            next_rom_addr     = rom_addr + 1'b1;
            // Go on to write the data to the PLL
            next_state        = WRITE;
         end
         
         // DI is setup so assert DWE, DEN, and RST_PLL.  Subtract one from the
         //    state count and go to wait for DRDY.
         WRITE: begin
            // Set WE and EN on PLL
            next_dwe          = 1'b1;
            next_den          = 1'b1;
            
            // Decrement the number of registers left to write
            next_state_count  = state_count - 1'b1;
            // Wait for the write to complete
            next_state        = WAIT_DRDY;
         end
         
         // Wait for DRDY to assert from the PLL.  If the state count is not 0
         //    jump to ADDRESS (continue reconfiguration).  If state count is
         //    0 wait for lock.
         WAIT_DRDY: begin
            if(DRDY) begin
               // Write is complete
               if(state_count > 0) begin
                  // If there are more registers to write keep going
                  next_state  = ADDRESS;
               end else begin
                  // There are no more registers to write so wait for the PLL
                  // to lock
                  next_state  = WAIT_LOCK;
               end
            end else begin
               // Keep waiting for write to complete
               next_state     = WAIT_DRDY;
            end
         end
         
         // If in an unknown state reset the machine
         default: begin
            next_state = RESTART;
         end
      endcase
   end
   
endmodule

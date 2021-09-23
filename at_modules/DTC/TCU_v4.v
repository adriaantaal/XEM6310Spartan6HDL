//Verilog HDL for "2016_PhotoShank", "TCU" "functional"

//AT explanation
//fundamentally it works on 2 clocks that are input
//'reset' is a slow clock that determines the base frequency 
	// TRIGGER in the padframe -> reset
//'clk_in' is a clock that determines the fast interpolation
	//CLK_IN in the padframe -> Phase interpolators (PIs)
			//PIA -> REF_CLK
			//PI0 -> CLK_IN_0
			//PI1 -> CLK_IN_1

			
//Now we have 2 fast clocks generated:
	//REF_CLK signals the start of counting by asserting clkPass
	//clk_in creates outClk synchronously
		//outClk stays high for width*clk_in
		//outClk is delayed by delay*clk_in



//Then, the output is compared between two TCU as an easy frequency doubling and phase comparison instrument


//[confirmed] So in order to make a 20MHz, 20% duty cycle clock on the output of the TCU comparator:
//reset = 20  MHz
//clkin = 100 MHz
//refclk = 100 MHz
//width of both TCU = 2 cycles
//delay0 = 0 cycles
//delay1 = 1 cycles

//Its best to use an input clock as low as possible
//This creates the cleanest clock through the lowpass filtering of the routing



//Now the phase interpolators should be adjusted to make the phase work arbitrarily


module TCU_v4 (reset, ref_clk, clk_in, delay, width, outClk);

input reset;
input ref_clk;
input clk_in;
input [5:0] delay;
input [5:0] width;
output outClk;

reg [5:0] delay_reg;
reg [5:0] width_reg;

reg [5:0] clk_counter;
reg outClk;
reg done; 

reg clkPass;

// when ref_clk goes high and done is low, allow
// clk_in to propagate through to the counter.
//
// negedge clk_in should always trigger loads during 
// reset.
//
// use the done signal to determine the state

always @ ( done or ref_clk ) begin
  if ( ref_clk & !done )
    clkPass = 1'b1;
  if ( done )
    clkPass = 1'b0;
end

//The output is fully synchronous (on and off) to CLKIN
	//either by clkpass
	//or directly by reset 
	
//The clkPass turns on with RefCLK 
//The clkPass turns off with RefCLK 
	//when done = 1



// getting power compiler to infer the gate:
// include an enable condition
// no setup condition for this because the enable signal is not clocked by
//  the same clock
// width condition
always @(posedge clk_in) begin
	if ( !reset ) begin
		delay_reg <= delay;
		width_reg <= width;
		done <= 1'b0;
		clk_counter <= 0;
		outClk <= 0;
	end
	else if ( clkPass ) begin
		if(clk_counter==delay_reg) begin
			outClk <= 1'b1;
			clk_counter <= clk_counter+1;
		end
		else if( clk_counter == delay_reg+width_reg) begin
			outClk <= 1'b0;
			done <= 1'b1;
		end
		else
			clk_counter <= clk_counter+1;
		end	
	else
	clk_counter <= clk_counter;
end

endmodule

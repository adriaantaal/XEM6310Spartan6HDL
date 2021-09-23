
module fifoindexcounter_v1(
	//from FPGA
	rst, //reset
	clk, // increment trigger 
	maxindex, //number of total items stored in fifo
	
	//to FPGA
	index
);

parameter N = 6;

//input
input wire rst;
input wire clk;
input wire [N-1:0] maxindex;

//output
output reg[N-1:0] index;

//sequential logic
always @(posedge clk or posedge rst) begin
	if(rst) begin
		index <= 6'b0;
	end else begin
			if(index == maxindex) begin
				index <= 6'b0;
			end else begin
				index <= index + 1;
			end
	end	
end

endmodule

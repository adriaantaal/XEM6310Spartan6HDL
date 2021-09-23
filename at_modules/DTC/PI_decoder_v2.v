//Verilog HDL for "2016_PhotoShank", "PI_decoder" "functional"


module PI_decoder_v2( 
bin_in,
ctrl,
en,
vdd,
vss
);
parameter NBIN =3;
parameter NDEC = (1<<NBIN)-1;

input [NBIN-1:0] bin_in;
input en;
output [NDEC:0] ctrl;
inout vdd;
inout vss;

reg [NDEC:0] decode_out;

always @(en or bin_in)
begin
	decode_out = 0;
	if(en) begin
		case (bin_in)
			3'h7: decode_out = 8'b00000011;
			3'h6: decode_out = 8'b00000110;
			3'h5: decode_out = 8'b00001100;
			3'h4: decode_out = 8'b00011000;
			3'h3: decode_out = 8'b00110000;
			3'h2: decode_out = 8'b01100000;
			3'h1: decode_out = 8'b11000000;
			3'h0: decode_out = 8'b10000001;
		endcase
	end
end
endmodule

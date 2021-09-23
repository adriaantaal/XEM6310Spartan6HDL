//Verilog HDL for "2016_PhotoShank", "johnsonCounter" "functional"
//The pattern is looped with 4 bits
//0001
//0011
//0111
//1111
//1110
//1100
//1000
//0000

//So you divide by 4
//And then this gets put into the PI_dig_frontend

//and repeat
`timescale 1ns/10ps

`celldefine

module johnsonCounter (
    Clock,
    rst,
    Count_out
    );

    //what are the input ports and their sizes.
    input Clock;
    input rst;
    //what are the output ports and their sizes.
    output [7:0] Count_out;
    //Internal variables
    reg [3:0] Count_temp;
    reg [3:0] Count_temp_bar;

    //Whenever the Clock changes from 0 to 1(positive edge) or 
    always @(posedge(Clock) or posedge(rst))  
    begin
      if ( rst ) begin
        Count_temp <= 8'b00000000;   
      end  
      else begin
      Count_temp <= {Count_temp[2:0],~Count_temp[3]};  
      Count_temp_bar <= {~Count_temp[2:0],Count_temp[3]};  
      end
    end

   
    //a change in Reset, execute the always block.
//    always @(posedge(Clock) or posedge(rst))
//    begin
//        if(rst == 1'b1)   begin  //when Reset is high 
//            Count_temp <= 8'b00000000;   
//		end  //The Count value is reset to "00000000".
//        else if(Clock == 1'b1)  begin  //When the Clock is high
//            //Left shift the Count value and at the same time
//            //negate the least significant bit.
//            Count_temp <= {Count_temp[2:0],~Count_temp[3]};  
//            Count_temp_bar <= {~Count_temp[2:0],Count_temp[3]};  
//		end 
//    end
    
    //The Count value is assigned to final output port.
    assign Count_out[3:0] = Count_temp;
    assign Count_out[7:4] = Count_temp_bar;
    
endmodule

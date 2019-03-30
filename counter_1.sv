////////////////////////////////////////////////////////////////////////////////// 
// Engineer: Mugilvanan Vinayagam
// 
// Create Date: 02/06/2019
// Module Name: counter 1
// Description: Used for orientations 180 and 225.
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
module counter_1(
	input clk,
	input reset,
	input clear,
	input enable,
	output logic [9 : 0] count);

	always_ff @(posedge clk) begin : proc_count //counter goes like 1023, 1022, 1021.....1, 0 
		if(reset) begin							//reset and clear sets the count to 1023
			count <= 10'h3ff;
		end else if (clear) begin
			count <= 10'h3ff;
		end else if (enable)begin				//enable makes the counter to count
			count <= count - 1;
		end else begin							//else it just stores the previous value
			count <= count;
		end
	end
endmodule

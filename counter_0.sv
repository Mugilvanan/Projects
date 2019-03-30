////////////////////////////////////////////////////////////////////////////////// 
// Engineer: Mugilvanan Vinayagam
// 
// Create Date: 02/06/2019
// Module Name: counter 0
// Description: Used for orientations 0 and 45.
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
module counter_0(
	input clk,
	input reset,
	input clear,
	input enable,
	output logic [9 : 0] count);

	always_ff @(posedge clk) begin : proc_count	//counter goes like 0, 1, 2, ......1023 if enable is high
		if(reset) begin							//reset clears the count
			count <= 0;
		end else if (clear) begin				//clear clears the count
			count <= 0;
		end else if (enable)begin				//enable makes the counter to count
			count <= count + 1;
		end else begin							//else it just stores the previous value
			count <= count;
		end
	end
endmodule

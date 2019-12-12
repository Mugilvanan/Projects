////////////////////////////////////////////////////////////////////////////////// 
// Engineer: Mugilvanan Vinayagam
// 
// Create Date: 02/06/2019
// Module Name: counter 2
// Description: Used for orientations 90 and 1355.
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
module counter_2(
	input clk,
	input reset,
	input clear,
	input enable,
	output logic [9 : 0] count);

	always_ff @(posedge clk) begin : proc_count				   //counter goes like 992, 960,...0, 993, 961,.....1, .....63, 31
		if(reset) begin										   //reset and clear sets the count to 992
			count <= 10'h3e0;
		end else if (clear) begin
			count <= 10'h3e0;
		end else if (enable && (count[9:5] != 5'b00000))begin  //enable makes the counter to count
			count <= count - 32;
		end else if (count[9:5] == 5'b00000) begin             //else it just stores the previous value
			count <= count + 10'h3e1;
		end else begin
			count <= count;
		end
	end
endmodule

////////////////////////////////////////////////////////////////////////////////// 
// Engineer: Mugilvanan Vinayagam
// 
// Create Date: 02/06/2019
// Module Name: counter 3
// Description: Used for orientations 270 and 315.
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
module counter_3(
	input clk,
	input reset,
	input clear,
	input enable,
	output logic [9 : 0] count);

	always_ff @(posedge clk) begin : proc_count						//counter goes like 31, 63, 95,....1023, 30, 62,......1022, 29,.....32, 0
		if(reset) begin												//reset and clear sets the count to 31
			count <= 10'd31;
		end else if (clear) begin
			count <= 10'd31;
		end else if (enable && (count[9:5] != 5'b11111))begin		//enable makes the counter to count
			count <= count + 32;
		end else if (count[9:5] == 5'b11111) begin					//else it just stores the previous value
			count <= count - 10'h3e1;
		end else begin
			count <= count;
		end
	end
endmodule

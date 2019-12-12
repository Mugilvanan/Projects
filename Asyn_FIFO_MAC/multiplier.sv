module Multiplier #(WIDTH = 4)(
	input  logic                   reset,
	input  logic                   clk,
	input  logic                   wFull,
	input  logic [WIDTH-1     : 0] D1,
	input  logic [WIDTH-1     : 0] D2,
	output logic                   wr_En,
	output logic [2*WIDTH - 1 : 0] product);
	
	// Simpler multiplier
	always_ff @(posedge clk) begin
		if (reset) begin	
			product <= 0;
			wr_En <= 0;
		end else begin
			if(~wFull) begin	
				product <= D1 * D2;
				wr_En <= 1;
			end else begin
				product <= 0;
				wr_En <= 0;
			end
		end
	end
endmodule
	
	

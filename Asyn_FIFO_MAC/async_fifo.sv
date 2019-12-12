// ----------------------------------------------------------------------------------
// -- Module Name  : Async_FIFO
// -- Engineer Name: Mugilvanan Vinayagam
// -- Description  : Systemverilog implementation of a simple Asynchronous FIFO with
//                   gray counter for read and write pointer counter.
// ---------------------------------------------------------------------------------

module Async_FIFO #(WIDTH = 8, 
	DEPTH = 16)(
	input  logic               wclk,
	input  logic               rclk,
	input  logic               r_rst_n,
	input  logic               w_rst_n,
	input  logic               wr_en,
	input  logic [WIDTH-1 : 0] wr_data,
	input  logic               rd_en,
	output logic [WIDTH-1 : 0] rd_data,
	output logic               full,
	output logic               empty);

	localparam ADDR_WIDTH = $clog2(DEPTH);

	logic [ADDR_WIDTH : 0] wr_ptr, wr_ptr_sync, wr_ptr_sync1, wr_ptr_g;
	logic [ADDR_WIDTH : 0] rd_ptr, rd_ptr_sync, rd_ptr_sync1, rd_ptr_g;

	logic [WIDTH-1 : 0] memory [DEPTH];

	// Gray code to binary code converter	
	function automatic logic [ADDR_WIDTH : 0] G2B(input logic [ADDR_WIDTH : 0] G);
		int i;
		logic [ADDR_WIDTH : 0] B;
		for(i = 0; i <= ADDR_WIDTH; i++)
			B[i] = ^(G >> i);
		return B;
	endfunction

	// Binary code to gray code converter
	function automatic logic [ADDR_WIDTH : 0] B2G(input logic [ADDR_WIDTH : 0] B);
		logic [ADDR_WIDTH : 0] G;
			G =  B ^ (B >> 1);
		return G;
	endfunction
	
	// FIFO write logic
	always_ff @(posedge wclk) begin
		if (~w_rst_n) begin
			wr_ptr <= 0;
			rd_ptr_sync <= 0;
			rd_ptr_sync1 <= 0;
		end else begin
			// Synchronization of read pointer with write clock
			{rd_ptr_sync1, rd_ptr_sync} <= {rd_ptr_sync, B2G(rd_ptr)};
			if (~full && wr_en) begin
				memory[wr_ptr[ADDR_WIDTH-1:0]] <= wr_data;
				wr_ptr <= wr_ptr + 1;
			end
		end
	end

	// FIFO read logic
	always_ff @(posedge rclk) begin
		if (~r_rst_n) begin
			rd_ptr <= 0;
			wr_ptr_sync <= 0;
			wr_ptr_sync1 <= 0;
		end else begin
			// Synchronization of write pointer with read clock
			{wr_ptr_sync1, wr_ptr_sync} <= {wr_ptr_sync, B2G(wr_ptr)};
			if (~empty && rd_en) begin
				rd_data <= memory[rd_ptr[ADDR_WIDTH-1:0]];
				rd_ptr <= rd_ptr + 1;
			end
		end
	end

	// Full and Empty flag generation
	always_comb begin
		wr_ptr_g = B2G(wr_ptr);
		rd_ptr_g = B2G(rd_ptr);
		if((rd_ptr_sync1 ^ wr_ptr_g) == 4'd12)
			full = 1;
		else
			full = 0;

		if(wr_ptr_sync1 == rd_ptr_g)
			empty = 1;
		else
			empty = 0;

	end 
endmodule 
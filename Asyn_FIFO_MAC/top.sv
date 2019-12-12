// ----------------------------------------------------------------------------------
// -- Module Name  : MAC
// -- Engineer Name: Mugilvanan Vinayagam
// -- Description  : Synthesizable top module for the MAC design with a multipler, 
// --                asynchronous FIFO, accumulator and divider. 
// ---------------------------------------------------------------------------------

module MAC (wclk, rclk, reset, D1, D2, average, avg_valid);
	
	parameter WIDTH=4;
	input  logic wclk;
	input  logic rclk;
	input  logic reset;
	output logic [2*WIDTH-1 : 0] average;
	output logic avg_valid; 
	input  logic [WIDTH-1 : 0] D1;
	input  logic [WIDTH-1 : 0] D2;
	logic wFull;
	logic r_rst_n;
	logic w_rst_n;
	logic [2*WIDTH-1 : 0] product, data;
	logic wr_En;
	logic rd_En, rEmpty;

	always_ff @(posedge wclk) begin
		w_rst_n <= ~reset;
	end

	always_ff @(posedge rclk) begin
		r_rst_n <= ~reset;
	end
	
	Multiplier #(WIDTH)MUL(
		.clk(wclk),
		.reset(reset),
		.D1,
		.D2,
		.wFull,
		.product,
		.wr_En);
		
	Async_FIFO #(2*WIDTH)FIFO(
		.wclk,
		.rclk,
		.r_rst_n,
		.w_rst_n,
		.wr_en(wr_En),
		.rd_en(rd_En),
		.wr_data(product),
		.rd_data(data),
		.full(wFull),
		.empty(rEmpty));
		
	AccuDivider #(2*WIDTH)ACCUDIV(
		.clk(rclk),
		.reset(reset),
		.data,
		.rd_En,
		.rEmpty,
		.average,
		.avg_valid);
		
endmodule
		
	
	

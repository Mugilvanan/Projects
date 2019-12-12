module top_module;

	logic wclk = 0;
	logic rclk = 0;
	logic reset;
	logic r_rst_n;
	logic w_rst_n;
	logic [3 : 0] D1;
	logic [3 : 0] D2;
	logic [7 : 0] product, data, average;
	logic wr_En, wFull;
	logic rd_En, rEmpty;
	logic avg_valid;
	
	Multiplier MUL(
		.clk(wclk),
		.reset(reset),
		.D1,
		.D2,
		.wFull,
		.product,
		.wr_En);
		
	Async_FIFO FIFO(
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
		
	AccuDivider ACCDIV(
		.clk(rclk),
		.reset(reset),
		.data,
		.rd_En,
		.rEmpty,
		.average,
		.avg_valid);
		
	always #7 rclk = ~rclk;
	always #10 wclk = ~wclk;
		
	// Gives 100 consecutive inputs
	task mul_store_accu_div();
		repeat(100) begin
			if (~wFull) begin
				D1 <= $urandom%16;
				D2 <= $urandom%16;
			end else begin
				D1 <= 0;
				D2 <= 0;
			end
			@(posedge wclk);
		end
		@(posedge wclk);
		D1 <= 0;
		D2 <= 0;
	endtask
	
	initial begin
		r_rst_n = 0;
	    repeat(10) @(posedge rclk);
		r_rst_n = 1;
	end
	
	initial begin
		w_rst_n = 0;
		reset = 1;
	    repeat(10) @(posedge wclk);
		w_rst_n = 1;
		repeat(10) @(posedge wclk);
		reset = 0;
		mul_store_accu_div();
		repeat(10) @(posedge wclk);
		reset = 1;
		r_rst_n = 0;
		w_rst_n = 0;
		repeat(10) @(posedge wclk);
		$finish;
	end
endmodule
		
	
	

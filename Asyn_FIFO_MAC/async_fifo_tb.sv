// ----------------------------------------------------------------------------------
// -- Module Name  : top
// -- Engineer Name: Mugilvanan Vinayagam
// -- Description  : A simple testbench for Asynchronous FIFO.
// ---------------------------------------------------------------------------------

module top;
	
	parameter WIDTH = 4;
	logic               wclk = 0;
	logic               rclk = 0;
	logic               reset;
	logic               wr_en;
	logic [WIDTH-1 : 0] wr_data;
	logic               rd_en;
	logic [WIDTH-1 : 0] rd_data;
	logic               almost_full;
	logic               almost_empty;
	logic               full;
	logic               empty;

	always #10 wclk = ~wclk;
	always #5  rclk = ~rclk;

	Async_FIFO DUT(.*);
	
	logic [WIDTH-1 : 0] count;

	task write_till_full();
		count = 0;
		while(full != 1) begin
			wr_en = ~full;
			wr_data = count;
			count = count + 1;
			@(posedge wclk);
		end 
		wr_en = 0;
		wr_data = 0;
	endtask 

	initial begin
		reset = 1;
		repeat(10) @(posedge wclk);
		reset = 0;
		repeat(10) @(posedge wclk);

		write_till_full();
		repeat(10) @(posedge wclk);
		$finish;
	end
	
	initial
		$monitor("%b %b %b\n", DUT.wr_ptr_g, DUT.rd_ptr_sync1, (DUT.wr_ptr_g ^ DUT.rd_ptr_sync1));
endmodule
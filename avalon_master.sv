`timescale 1 us/ 1 ps

module avalon_master();
	logic clk = 1'b1;
	logic reset = 1'b1;
	logic read, write;
	logic [7:0] writedata;
	logic [7:0]address;
	logic waitrequest;
	logic [7:0]readdata;

	logic wait_temp = 1'b0;

	logic neg_edge;					// for falling edge detector

	time CLK_PERIOD = 100;			// frequency = 10 kHZ => time_period = 100 us

	// logic rd, wr;
	logic rd1, rd2, rd3, rd4, rd5;
	logic wr1, wr2, wr3, wr4, wr5;

    clocking cb @(posedge clk);
        default input #0step output #500;
        output wr1, rd1;
    endclocking
	always #(CLK_PERIOD/2) clk = ~clk;

avalon_slave   DUT	( .clk(clk),							
						  .reset(reset),					
						  .address(address),             
						  .Write(write),                   
						  .read(read),					
						  .waitrequest(waitrequest),       		
						  .writedata(writedata),			
						  .readdata(readdata)			
						);										//DUT Instantiation

	always_ff @(posedge clk) 						//Pipelinig waitrequest for one clock cycle to detect falling edge
		wait_temp <= waitrequest;
		
	assign neg_edge = wait_temp & (~waitrequest);   //Falling edge detection

	initial begin
		reset = 1'b1; read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
		repeat(3) @(posedge clk);
		reset = 1'b0;
		$display("!!!!!Reading the default values!!!!!");
        @(posedge clk)read = 1'b1; write = 1'b0; address = 8'd0; writedata = 8'd0;
        @(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
        @(neg_edge);																	//Giving input after detecting falling edge of waitrequest
        @(posedge clk)read = 1'b1; write = 1'b0; address = 8'd1; writedata = 8'd0;
        @(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
        @(neg_edge);
        @(posedge clk)read = 1'b1; write = 1'b0; address = 8'd2; writedata = 8'd0;
        @(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
        @(neg_edge);
        @(posedge clk)read = 1'b1; write = 1'b0; address = 8'd3; writedata = 8'd0;
        @(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
        @(neg_edge);
        @(posedge clk)read = 1'b1; write = 1'b0; address = 8'd4; writedata = 8'd0;
        @(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
        @(neg_edge);
        @(posedge clk)read = 1'b1; write = 1'b0; address = 8'd5; writedata = 8'd0;
        @(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
        @(neg_edge);
        @(posedge clk)read = 1'b1; write = 1'b0; address = 8'd6; writedata = 8'd0;
        @(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
        @(neg_edge);
        $display("\n!!!!!Writing values and reading it!!!!!");
		@(posedge clk)read = 1'b0; write = 1'b1; address = 8'd0; writedata = 8'd3;
		@(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
		@(neg_edge);
		@(posedge clk)read = 1'b0; write = 1'b1; address = 8'd3; writedata = 8'd72;
		@(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
		@(neg_edge);
		@(posedge clk)read = 1'b1; write = 1'b0; address = 8'd0; writedata = 8'd0;
		@(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
		@(neg_edge);
		@(posedge clk)read = 1'b0; write = 1'b1; address = 8'd4; writedata = 8'd23;
		@(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
		@(neg_edge);
		@(posedge clk)read = 1'b1; write = 1'b0; address = 8'd3; writedata = 8'd0;
		@(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
		@(neg_edge);
		@(posedge clk)read = 1'b0; write = 1'b1; address = 8'd0; writedata = 8'd23;
		@(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
		@(neg_edge);
		@(posedge clk)read = 1'b0; write = 1'b1; address = 8'd1; writedata = 8'd34;
		@(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
		@(neg_edge);
		@(posedge clk)read = 1'b0; write = 1'b1; address = 8'd2; writedata = 8'd127;
		@(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
		@(neg_edge);
		@(posedge clk)read = 1'b0; write = 1'b1; address = 8'd6; writedata = 8'd255;
		@(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
		@(neg_edge);
		@(posedge clk)read = 1'b0; write = 1'b1; address = 8'd3; writedata = 8'd200;
		@(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
		@(neg_edge);
		@(posedge clk)read = 1'b0; write = 1'b1; address = 8'd4; writedata = 8'd43;
		@(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;										
		@(neg_edge);
		@(posedge clk)read = 1'b1; write = 1'b0; address = 8'd0; writedata = 8'd0;
		@(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
		@(neg_edge);
		@(posedge clk)read = 1'b1; write = 1'b0; address = 8'd1; writedata = 8'd0;
		@(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
		@(neg_edge);
		@(posedge clk)read = 1'b1; write = 1'b0; address = 8'd2; writedata = 8'd0;
		@(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
		@(neg_edge);
		@(posedge clk)read = 1'b1; write = 1'b0; address = 8'd3; writedata = 8'd0;
		@(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
		@(neg_edge);
		@(posedge clk)read = 1'b1; write = 1'b0; address = 8'd4; writedata = 8'd0;
		@(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
		@(neg_edge);
		@(posedge clk)read = 1'b1; write = 1'b0; address = 8'd5; writedata = 8'd0;
		@(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
		@(neg_edge);
		@(posedge clk)read = 1'b1; write = 1'b0; address = 8'd6; writedata = 8'd0;
		@(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
		@(neg_edge);
        @(posedge clk)read = 1'b0; write = 1'b1; address = 8'd0; writedata = 8'd24;
        @(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
        @(neg_edge);
        @(posedge clk)read = 1'b0; write = 1'b1; address = 8'd1; writedata = 8'd66;
        @(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
        @(neg_edge);
        @(posedge clk)read = 1'b0; write = 1'b1; address = 8'd2; writedata = 8'd153;
        @(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
        @(neg_edge);
        $display("\n!!!!!Testing Version register with contiguous read-write-read!!!!!");
        @(posedge clk)read = 1'b1; write = 1'b0; address = 8'd5; writedata = 8'd0;
        @(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
        @(neg_edge);
        @(posedge clk)read = 1'b0; write = 1'b1; address = 8'd5; writedata = 8'd255;
        @(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
        @(neg_edge);
        @(posedge clk)read = 1'b1; write = 1'b0; address = 8'd5; writedata = 8'd0;
        @(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
        @(neg_edge);
        $display("!!!!!Write operation has no effect on the register!!!!! \n");
        $display("\n!!!!!Testing Reserved register with contiguous read-write-read!!!!!");
        @(posedge clk)read = 1'b1; write = 1'b0; address = 8'd5; writedata = 8'd0;
        @(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;        
        @(neg_edge);
        @(posedge clk)read = 1'b0; write = 1'b1; address = 8'd7; writedata = 8'd200;
        @(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
        @(neg_edge);
        @(posedge clk)read = 1'b1; write = 1'b0; address = 8'd7; writedata = 8'd0;
        @(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
        @(neg_edge);
        $display("!!!!!Both Read and Write operation has no effect on the register!!!!! \n");
        @(posedge clk)read = 1'b0; write = 1'b1; address = 8'd4; writedata = 8'd12;
        @(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;                                        
        @(neg_edge);
        @(posedge clk)read = 1'b1; write = 1'b0; address = 8'd0; writedata = 8'd0;
        @(posedge clk)  read = 1'b0; write = 1'b0; address = 8'd0; writedata = 8'd0;
		#600 $stop;
		end

		// always_ff @(posedge clk)
		// 	$display("time = %3d, reset = %b, read = %b, write = %b, waitrequest = %b, address =%2d, readdata = %2d, writedata = %2d", $time, reset, read, write, waitrequest, address, readdata, writedata);
		always_ff @(posedge read)
		begin
			// $display("\n");
			$display("Read signal given at %3d ns to address %2x", $time, address); 
		end

		always_ff @(posedge write)
		begin
			// $display("\n");
			$display("Write signal given at %3d ns to address %2x. Data written: %2x", $time, address, writedata);
		end		
		always_ff @(posedge neg_edge)
		begin
			if (rd5) begin
				$display("Read has been successfully done at %3d. Output Data: %2x", $time, readdata);
				$display("\n");
			end // if (rd)
			if (wr5) begin
				$display("Write has been successfully done at %3d.", $time);
				$display("\n");
			end				
		end	
//		always_ff @(posedge clk)
//		begin
        always  ##500 rd1 <= read; //rd2 <= rd1; rd3 <= rd2; rd4 <= rd3; rd5 <= rd4;
		always 	##500 wr1 <= write; //wr2 <= wr1; wr3 <= wr2; wr4 <= wr3; wr5 <= wr4;
//		end	
		endmodule // testbench
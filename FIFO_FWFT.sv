//////////////////////////////////////////////////////////////////////////////////
// Engineer   : Mugilvanan Vinayagam
// Module     : FIFO_FWFT
// Description: It is a first-word-fall-through asynchronous asymmetric FIFO.
/////////////////////////////////////////////////////////////////////////////////
module FIFO_FWFT(
	input wr_clk,
	input rd_clk,
	input reset,
	input wr_en,
	input [63 : 0]din,
	input rd_en,
	output logic full,
	output logic empty,
	output logic [127: 0]dout,
	output logic [10 : 0]rd_data_count);


	logic [10 : 0] head;
	logic [10 : 0] tail;
	bit [2047 : 0][63 : 0] memory;

	logic [10 : 0] head_temp;
	logic [10 : 0]rd_data_count1;

	assign rd_data_count = (rd_data_count1 > 0) ? (rd_data_count1 - 1) : 0;
	assign head_temp = head + 1;

	always_ff @(posedge wr_clk) begin
		if(reset) begin
			head <= 0;
			full <= 0;
		end else begin
			if (wr_en & ~full) begin
				memory[head] <= din;
				head <= head + 1;
			end 
			
			if (wr_en & (tail == head_temp))
				full <= 1'b1;
			else if ((full == 1'b1) && (head == tail))
				full <= 1'b1;
			else
				full <= 1'b0;
		end
	end

	always_ff @(posedge rd_clk) begin
		if(reset) begin
			empty <= 1;
			tail  <= 0;
			rd_data_count1 <= 0;
			dout  <= 0;
		end else begin
			if (rd_en & ~empty)
				tail <= tail + 2;

			if (rd_en & ~empty)
				dout <= {memory[tail+2], memory[tail+3]};
			else if (~empty)
				dout <= {memory[tail], memory[tail+1]};

			if ((tail + 2) == head)
				empty <= 1'b1;
			else if ((empty == 1'b1) && (head == tail))
				empty <= 1'b1;
			else if ((empty == 1'b1) && (head == (tail + 1)))
				empty <= 1'b1;
			else
				empty <= 1'b0;	

			if(wr_en & rd_en)
				rd_data_count1 <= rd_data_count1;
			else if(rd_en && (rd_data_count1 > 0))
				rd_data_count1 <= rd_data_count1 - 1;
			else if(wr_en)
				rd_data_count1 <= rd_data_count1 + 1;
			else
				rd_data_count1 <= rd_data_count1;
		end
	end

endmodule
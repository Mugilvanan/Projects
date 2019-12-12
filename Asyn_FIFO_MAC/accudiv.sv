// ----------------------------------------------------------------------------------
// -- Module Name  : AccuDivider
// -- Engineer Name: Mugilvanan Vinayagam
// -- Description  : Gives read request to the FIFO that lies before in the pipeline
// --                and accumulates the read data into the register to find average
// --                after every fourth read data.
// ----------------------------------------------------------------------------------

module AccuDivider #(WIDTH = 8)(
	input  logic               clk,
	input  logic               reset,
	input  logic [WIDTH-1 : 0] data,
	input  logic               rEmpty,
    output logic               rd_En,
	output logic [WIDTH-1 : 0] average,
	output logic               avg_valid);
	
	logic [1 : 0] count;
	logic rd_En1;
	logic [WIDTH+1 : 0] data_reg;
	
	// Input FF-stage
	always_ff @(posedge clk) begin
		if (reset) begin
			count <= 0;
			data_reg <= 0;
		end else begin
			{rd_En1, rd_En} <= {rd_En, ~rEmpty};
			if (rd_En1 & ~rEmpty) begin
				count <= count + 1;
				if(count == 0)
					data_reg <= data;
				else
					data_reg <= data_reg + {2'b0, data};
			end else if (rd_En1 == 1 && count == 0) begin
				data_reg <= 0;
			end
		end
	end
	
	// Output Combinational logic
	always_comb begin
		if (reset) begin
			average = 0;
			avg_valid = 0;
		end else if (count == 0) begin
			average = data_reg >> 2;
			avg_valid = (data_reg == 0) ? 1'b0 : 1'b1;
		end else begin
			average = 0;
			avg_valid = 0;
		end
	end
endmodule

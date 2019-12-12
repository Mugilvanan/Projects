//Module: Avalon-slave & Serial_In_Parallel_Out shift register
//Author: Mugilvanan Vinayagam
//Date  : 11/12/2018	

typedef struct packed
{
	logic [7:0] ADDR_NUMPKTS  ;
	logic [7:0] ADDR_START    ;
	logic [7:0] ADDR_STOP     ;
	logic [7:0] ADDR_PKTLENGTH;
	logic [7:0] ADDR_PAYLOAD  ;
	logic [7:0] ADDR_VERSION  ;
	logic [7:0] ADDR_SCRATCH  ;
	logic [7:0] ADDR_RES      ;
} register_set;



module avalon_slave (
	avalon_interface.slave slv
);


	bit [3:0] rd_delay,wr_delay;
//initialize the default values for all the registers
	register_set registers;

	sipo #(4) rd_inst (slv.clk, slv.reset, slv.read, rd_delay); //Delay the pulse for 4 clk cycles in parallel
	sipo #(4) wr_inst (slv.clk, slv.reset, slv.write, wr_delay);//Delay the pulse for 4 clk cycles in parallel

	always_comb begin : proc_wait_req
		if(slv.reset)
			slv.waitrequest = 1;
		else
			slv.waitrequest = (|rd_delay) | (|wr_delay);
	end

	always_ff @(posedge slv.clk) begin : proc_reg_set
		if(slv.reset) begin
			registers <= '{8'b0, 8'b0, 8'b0, 8'b0, 8'b0, 8'h12, 8'b0, 8'b0};
		end else if (slv.address <= 6) //Valid Address Range 0-6
			begin
				if((slv.read)&(~(|wr_delay))) //Read Priority and Don't write while Read in progress
					unique case (slv.address)
						0       : slv.readdata <= registers.ADDR_NUMPKTS;
						1       : slv.readdata <= registers.ADDR_START;
						2       : slv.readdata <= registers.ADDR_STOP;
						3       : slv.readdata <= registers.ADDR_PKTLENGTH;
						4       : slv.readdata <= registers.ADDR_PAYLOAD;
						5       : slv.readdata <= registers.ADDR_VERSION;
						6       : slv.readdata <= registers.ADDR_SCRATCH ;
						default : registers <= '{8'b0, 8'b0, 8'b0, 8'b0, 8'b0, 8'h12, 8'b0, 8'b0};
					endcase
				else if ((slv.write)&(~(|rd_delay))) //Don't read while write in progress
					unique case (slv.address)
						0       : registers.ADDR_NUMPKTS		<= slv.writedata;
						1       : registers.ADDR_START			<= slv.writedata;
						2       : registers.ADDR_STOP			<= slv.writedata;
						3       : registers.ADDR_PKTLENGTH		<= slv.writedata;
						4       : registers.ADDR_PAYLOAD		<= slv.writedata;
					//	5       : registers.ADDR_VERSION		<= writedata; //Don't write to Register 5
						6       : registers.ADDR_SCRATCH		<= slv.writedata;
						default : registers <= '{8'b0, 8'b0, 8'b0, 8'b0, 8'b0, 8'h12, 8'b0, 8'b0};
					endcase
			end
	end

endmodule


module sipo #(parameter W = 4) (
	input              clk  , // Clock
	input              reset, // Reset
	input              d    ,
	output bit [W-1:0] q
);

	bit [W-2:0] temp;

	always_comb begin : proc_out
		if(reset)
			q = 0;
		else
			q = {temp,d};
	end

	always_ff @(posedge clk) begin : proc_q
		if(reset) begin
			temp <= 0;
		end else begin
			temp <= {temp[W-2:0],d};
		end
	end

endmodule 
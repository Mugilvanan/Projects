//***************************************************************************************
// MODULE : axi4_lite_master
// AUTHOR : Mugilvanan Vinayagam
// DATE   : 11/22/2018
// DESCRIPTION
// -----------
//  This is a synthesizable testbench that instantiates Top module and generates inputs to Top module based on 
//  clock and reset signal given from emulator.
//
//***************************************************************************************
module testbench_synth(
	input logic axi4_lite_aclk,
	input logic axi4_lite_aresetn
	);

	parameter ADDRESS_WIDTH   = 32 ;    //Address pointer data width
	parameter REG_DATA_WIDTH  = 32 ;    //Input data width and output data width
	parameter LEN_WIDTH		  = 5  ;
	parameter DATA_RANGE      = (1 << REG_DATA_WIDTH) - 1; 	
	parameter CNT_WIDTH		  = 8  ;

	logic WRITE;
	logic READ;
	logic DATA_VALID;
	logic [REG_DATA_WIDTH - 1 : 0] DATA_IN;
	logic [LEN_WIDTH - 1 : 0] DATA_LENGTH;
	logic [ADDRESS_WIDTH - 1 : 0] CPU_ADDR;
	logic [REG_DATA_WIDTH - 1 : 0] DATA_OUT;
	logic OUT_VALID;
	logic BUSY;	
	logic [LEN_WIDTH - 1 : 0]error_count;

	bit [CNT_WIDTH - 1 : 0] count;

	bit [14 : 0][CNT_WIDTH - 1 : 0]data_len_array = {8'd1, 8'd2, 8'd3, 8'd4, 8'd5, 8'd6, 8'd7, 8'd8, 8'd9, 8'd10, 8'd11, 8'd12, 8'd13, 8'd14, 8'd15};

	int data_len_cnt = 0;
	int data_array_cnt = 0;

	logic wr_st, rd_st;
	logic [REG_DATA_WIDTH - 1 : 0] rn_data;
	logic [(ADDRESS_WIDTH >> 1) - 1 : 0] rn_addr;

	bit [1 : 120][REG_DATA_WIDTH - 1 : 0]wr_data;
	bit [1 : 120][REG_DATA_WIDTH - 1 : 0]rd_data;

	logic [6 : 0]wr_pointer = 0;
	logic [6 : 0]rd_pointer = 0;

	int wr_gen = 0;
	int rd_gen = 0;

	top DUT(.*);

	lfsr_32bit L1(.clk(axi4_lite_aclk), .rst_n(axi4_lite_aresetn), .prng_out(rn_data));	
	lfsr_16bit L2(.clk(axi4_lite_aclk), .rst_n(axi4_lite_aresetn), .prng_out(rn_addr));	

	always_ff @(posedge axi4_lite_aclk or negedge axi4_lite_aresetn) begin
			if(~axi4_lite_aresetn) begin
				count <= 0;
				rd_pointer <= 0;
				wr_pointer <= 0;
			end else begin
				count <= count + 1;
				if(OUT_VALID) begin
					rd_pointer <= rd_pointer + 1;
					rd_data[rd_pointer] <= DATA_OUT;
				end
				if(DATA_VALID) begin
					wr_pointer <= wr_pointer + 1;
					wr_data <= DATA_IN;
				end
			end
	end	

	always_ff @(posedge axi4_lite_aclk or negedge axi4_lite_aresetn) begin
		if(~axi4_lite_aresetn) begin
			DATA_IN <= 32'd0;
			DATA_VALID <= 1'b0;
			DATA_LENGTH <= 0;
			CPU_ADDR <= 32'd0;
			WRITE <= 1'b0;
			READ <= 1'b0;
			wr_st <= 1'b0;
			rd_st <= 1'b0;
		end
		else if(data_len_cnt < 16) begin
			if (BUSY == 1'b0) begin
				case(count[5:0])
				6'b000000: begin
					WRITE <= 1'b1;
					wr_st <= 1'b1;
					rd_st <= 1'b0;
					READ <= 1'b0;
					data_len_cnt <= data_len_cnt + 1;
					data_array_cnt <= 0; 
					DATA_IN <= rn_data;
					DATA_VALID <= 1'b1;
					CPU_ADDR <= {16'd0, rn_addr};
					DATA_LENGTH <= data_len_array[data_len_cnt]; 
				end
				6'b100000: begin
					READ <= 1'b1;
					WRITE <= 1'b0;
					wr_st <= 1'b0;
					rd_st <= 1'b1;
				end
				default: begin
					WRITE <= 1'b0;
					READ <= 1'b0;
				end
				endcase
			end
			if (data_array_cnt < (DATA_LENGTH-1) && (wr_st & ~rd_st)) begin
				DATA_IN <= rn_data;
				data_array_cnt <= data_array_cnt + 1;
			end
			else if(DATA_VALID == 1'b1) begin
				DATA_IN <= 32'b0;
				DATA_VALID <= 1'b0;
			end
		end
                else if(data_len_cnt > 15 && wr_gen < 65536) begin
                        if (BUSY == 1'b0) begin
                                case(count[5:0])
                                6'b000000, 6'b100000: begin
                                        WRITE <= 1'b1;
                                        wr_st <= 1'b1;
                                        rd_st <= 1'b0;
                                        READ <= 1'b0;
                                        wr_gen <= wr_gen + 16;
                                        data_array_cnt <= 0;
                                        DATA_IN <= rn_data;
                                        DATA_VALID <= 1'b1;
                                        CPU_ADDR <= wr_gen;
                                        DATA_LENGTH <= 16;
                                end
                                default: begin
                                        WRITE <= 1'b0;
                                        READ <= 1'b0;
                                end
                                endcase
                        end
                        if (data_array_cnt < (DATA_LENGTH-1) && (wr_st & ~rd_st)) begin
                                DATA_IN <= rn_data;
                                data_array_cnt <= data_array_cnt + 1;
                        end
                        else if(DATA_VALID == 1'b1) begin
                                DATA_IN <= 32'b0;
                                DATA_VALID <= 1'b0;
                        end
                end
                else if(data_len_cnt > 15 && rd_gen < 65536) begin
                        if (BUSY == 1'b0) begin
                                case(count[5:0])
                                6'b000000, 6'b100000: begin
                                        WRITE <= 1'b0;
                                        wr_st <= 1'b0;
                                        rd_st <= 1'b1;
                                        READ <= 1'b1;
                                        rd_gen <= rd_gen + 16;
                                        data_array_cnt <= 0;
                                        DATA_IN <= 0;
                                        DATA_VALID <= 1'b0;
                                        CPU_ADDR <= rd_gen;
                                        DATA_LENGTH <= 16;
                                end
                                default: begin
                                        WRITE <= 1'b0;
                                        READ <= 1'b0;
                                end
                                endcase
                        end
                end

	end
endmodule

//***************************************************************************************
// MODULE :	Block RAM
// AUTHOR : Shiva Prasad Rangaswamy, Mugilvanan Vinayagam
// DATE   :	11/18/2018
// DESCRIPTION
// -----------
//	This is a block RAM module whose address with is 16 bits and data width is 32 bits.
//
//***************************************************************************************

module block_ram
#( parameter REG_DATA_WIDTH = 32,
   parameter ADDRESS_WIDTH  = 16  
 )
 (
   input  logic 						 clk   		,
   input  logic							 reset      ,
   input  logic [REG_DATA_WIDTH - 1 : 0] data_in	,
   input  logic [ADDRESS_WIDTH - 1  : 0] wr_addr    ,
   input  logic [ADDRESS_WIDTH - 1  : 0] rd_addr    ,
   input  logic							 wr_en     	,
   input  logic 						 rd_en      ,
   output logic 						 data_valid	,
   output logic [REG_DATA_WIDTH - 1 : 0] data_out	
   );

 	parameter DEPTH = 1 << ADDRESS_WIDTH; 
 	bit [DEPTH - 1 : 0][REG_DATA_WIDTH - 1 : 0] memory;
 	int i;

 	// logic [REG_DATA_WIDTH - 1 : 0] temp_data;
 	// logic temp_valid;

 	always_ff @(posedge clk) begin : proc
 		if (reset) begin
			for(i = 0; i < DEPTH; i++) begin
				memory[i] <= 32'd0;
			end
 		end
		else if (wr_en & ~rd_en) begin
			memory[wr_addr] <= data_in;
		end
		else if (rd_en & ~wr_en) begin
			data_out <= memory[rd_addr];
			data_valid <= rd_en;
		end
		else begin
			data_out <= 32'b0;
			data_valid <= 1'b0;
		end
 	end
 endmodule // block_ram_32
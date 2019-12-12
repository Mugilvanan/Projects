////////////////////////////////////////////////////////////
// <avalon_RW>.sv - <slave signals generation>//
// Author:Mugilvanan Vinayagam
// Date:10/21/2018//
////////////////////////////////////////////////////////////////

module avalon_slave( input clk,						// Interface clock
						 input reset,					// Reset signal
						 input [7:0]address,             // Register Address
						 input Write,                   // Register Write Strobe
						 input read,					// Register Read Strobe
						 output logic waitrequest,       		// Wait request
						 input [7:0]writedata,			// Register Write Data
						 output logic [7:0]readdata			// Register Read Data
						);

logic [2:0] count = 3'b000;				//counter variable
logic [7:0] temp;						//temporary output variable
logic start;							//To start and maintain count 
logic wait_temp;		

import packages::*;						//importing package

assign wait_temp = (count < 3'd4 && reset == 1'b0)?(read | Write | wait_temp):1'b0;
assign readdata = (count == 3'd4)?temp:8'b0;
assign waitrequest = wait_temp;

always_ff @(posedge clk) begin
	if(reset) begin
		count <= 3'd0;
		start <= 1'b0;
	end 
	else begin
		if(read | Write) begin								//Counter starts once read or write comes
			count <= 3'b0;
			start <= 1'b1;
		end 
		else if(start == 1'b1 && count < 4) begin
			count <= count + 3'd1; 
		end 
		else if(count == 4) begin							//Counter stops when count of 4 is reached
			count <= 3'd0;
			start <= 1'b0;
		end
		else begin
			count <= 3'd0;
			start <= 1'b0;
		end
    end
end // always_ff @(posedge clk)
always_ff @(posedge clk)
begin
	if(reset) begin
		temp = 8'b0;
		Avalon_write_default();								//Function defined in package are called based on reset, read and Write signal
	end else if(read) begin
		temp = Avalon_read(address[2:0]);
	end else if(Write) begin
		Avalon_write(address[2:0], writedata);
		temp = 8'b0;
	end
end
endmodule
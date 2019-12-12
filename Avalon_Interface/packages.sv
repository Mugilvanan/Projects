package packages;
typedef struct packed{ 											//Struct of registers
	logic [7:0] ADDR_NUMPKTS; 
	logic [7:0] ADDR_START; 
	logic [7:0] ADDR_STOP; 
	logic [7:0] ADDR_PKTLENGTH; 
	logic [7:0] ADDR_PAYLOAD; 
	logic [7:0] ADDR_VERSION; 
	logic [7:0] ADDR_SCRATCH; 
	logic [7:0] ADDR_RES;} register_set;

register_set registers;											//Instantiation of struct

function logic [7:0] Avalon_read (input [2:0]address);			//Read function
	begin
		case(address)
			3'b000:	return registers.ADDR_NUMPKTS;
			3'b001: return registers.ADDR_START;
			3'b010: return registers.ADDR_STOP;
			3'b011: return registers.ADDR_PKTLENGTH;
			3'b100: return registers.ADDR_PAYLOAD;
			3'b101: return registers.ADDR_VERSION;
			3'b110: return registers.ADDR_SCRATCH;
			default: return 8'b0;							    //Does not read from reserved register
		endcase
	end	
endfunction : Avalon_read

function void Avalon_write(input [2:0]address, input [7:0]writedata);		//Write function
	begin
		case(address)
			3'b000: registers.ADDR_NUMPKTS = writedata;
			3'b001: registers.ADDR_START = writedata;
			3'b010: registers.ADDR_STOP = writedata;
			3'b011: registers.ADDR_PKTLENGTH = writedata;
			3'b100: registers.ADDR_PAYLOAD = writedata;
			3'b110: registers.ADDR_SCRATCH = writedata;
			default: return;												//Does not write in version and reserved register
		endcase
	end	
	endfunction : Avalon_write		

function void Avalon_write_default();										//Write default function - Called on reset
	begin
		registers.ADDR_NUMPKTS = 8'd0;
		registers.ADDR_START = 8'd0;
		registers.ADDR_STOP = 8'd0;
		registers.ADDR_PKTLENGTH = 8'd0;
		registers.ADDR_PAYLOAD = 8'd0;
		registers.ADDR_SCRATCH = 8'd0;
		registers.ADDR_VERSION = 8'h12;
	end	
	endfunction : Avalon_write_default	

endpackage
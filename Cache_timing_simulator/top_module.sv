// --------------------------------------------------------------------------------------
// -- Module Name  : top_module
// -- Engineer Name: Mugilvanan Vinayagam
// -- Description  : Reads the instructions file and sends the instructions to the cache.
// --------------------------------------------------------------------------------------

`timescale 1ns/1ps
// importing parameter package
import parameters::*;

// Module definition

module top_module ();

	string filename;
	integer mode;
	integer count = 0; 
	int fd;
	integer n;
	logic busy;

	logic valid;
	logic [I_ADDR - 1 : 0] instr_addr;
	logic [ADDR_LEN - 1 : 0] input_address;
	string line;

	real D_hit_ratio = 0.000;
	real I_hit_ratio = 0.000;

	L1_split_cache DUT(.*);

	initial begin
		if($value$plusargs("FILE=%s", filename)) 					//assigning the filename to file
			count = count + 1;
		if($value$plusargs("MODE=%d", mode))						//assigning the mode 0 or 1
			count = count + 1;
		if(count < 2) begin			
			$display("ERROR: simulation stopped - Reason: less arguments, syntax: vsim <sim_file_name> -c +FILE=<filename> +MODE=<mode>");
			$stop;
		end
		if(mode!=0 && mode!=1 && mode!=2) begin						//checking if the mode is 0 or 1 
			$display("ERROR: simulation stopped - Reason: mode should be either 0 or 1");
			$stop;
		end

		fd = $fopen(filename, "r");									
		if(fd == 0) begin											//checking if the file is available
			$display("ERROR: simulation stopped - Reason: File not found");
			$stop;
		end

		while(!$feof(fd)) begin										//while runs until end of file is found
			#5
			if(busy == 1'b0) begin
				if($fscanf(fd, "%d ", n) == 1) begin
					if (n == 8 || n == 9) begin						//if n is 8 or 9 set valid bit is 1 and set bits to zero
						valid = 1'b1;
						instr_addr = 24'b0;
						input_address = 32'b0;
					end 
					else if (n == 2) begin							// if n is 2 get the instruction
						if($fscanf(fd, "%06x ", instr_addr) == 1) begin
							valid = 1'b1;
							input_address = {8'b0, instr_addr};
						end
						else begin
							$fgets(line, fd); 						// gets the next line
							valid = 1'b0;
							instr_addr = 24'b0;
							input_address = 32'b0;
						end	
					end
					else if (n == 0 || n == 1 || n == 3 || n == 4) begin
						if($fscanf(fd, "%08x ", input_address) == 1) begin
							valid = 1'b1;
							instr_addr = 24'b0;
						end	
						else begin
							$fgets(line, fd);
							valid = 1'b0;
							instr_addr = 24'b0;
							input_address = 32'b0;
						end
					end
				end
				else begin
					$fgets(line, fd);
					valid = 1'b0;
					instr_addr = 24'b0;
					input_address = 32'b0;
				end	
			end		
			else
				valid = 1'b0;
			// $display("%d %08x %b %b %3d", n, input_address, valid, busy, $time);
		end	
		#20
                D_hit_ratio   = (100.00000 * DUT.D_hit_count)/(1.0000 * DUT.D_access_count);
                I_hit_ratio   = (100.00000 * DUT.I_hit_count)/(1.0000 * DUT.I_access_count);
                $display("INSTRUCTION CACHE STATISTICS: ");
                $display("Instruction_cache Read_count   = %7d", DUT.I_read_count);
                $display("Instruction_cache Write count  =       0");
                $display("Instruction_cache Hit_count    = %7d", DUT.I_hit_count);
                $display("Instruction_cache Miss_count   = %7d", DUT.I_miss_count);
                $display("Instruction_cache Hit Ratio    = %.5f", I_hit_ratio);
                $display("\n\n DATA CACHE STATISTICS: ");
                $display("Data_cache read_count          = %7d", DUT.D_read_count);
                $display("Data_cache write_count         = %7d", DUT.D_write_count);
                $display("Data_cache hit_count           = %7d", DUT.D_hit_count);
                $display("Data_cache miss_count          = %7d", DUT.D_miss_count);
                $display("Datacache Hit Ratio            = %.5f", D_hit_ratio);		
	end
endmodule
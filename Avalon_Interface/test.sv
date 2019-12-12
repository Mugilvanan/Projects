`timescale 1ns/1ps

// Module      : Test
// Author      : Mugilvanan Vinayagam
// Date        : 11/12/2018
// Description : Systemverilog program block to feed inputs to the avalon master-slave design. 	

program test(avalon_interface.master mas);
	integer error_count = 0;

logic [7:0] reference_ini [0:7] = {0,0,0,0,0,8'h12,0,0}; //for default value self check
logic [7:0] reference_pat_rd [*];  //Associative array for reference 
logic [7:0] temp_address;
logic [7:0] temp_data;
integer i;
initial
begin
	mas.reset_sys(); 		//calling reset task
	reference_pat_rd[5] = 8'h12;
	reference_pat_rd[7] = 8'h0;
	for(i=0; i<7; i++) begin
	//Skim the inital Values
		#1
		mas.read_mm(i[7:0]);				//Calling read task
		if(mas.readdata!=reference_ini[i]) begin //Self Check
			$display("Missmatch in Read, Address: %d,Read: %h,Expected Read: %h", i, mas.readdata, reference_ini[i]);
			error_count = error_count + 1; //counting number of mis-match
		end
	end

	if(error_count==0)								//Checking mismatch count
		$display("Inital values Verified!!");			
	else	
	$display("Error!! Count :%d",error_count);	
	
	error_count = 0;

	for(i=0; i<27; i++) begin
		#1
		temp_address = $urandom_range(6, 0);		//randomize address to a range
		temp_data = $urandom_range(255, 0);			//generating random data to feed	
		reference_pat_rd[temp_address] = (temp_address != 5)?temp_data[7:0]:8'h12;	//creating a refernce array for self check after read
		mas.write_mm(temp_address[7:0], temp_data[7:0]); //Write task
		mas.read_mm(temp_address[7:0]); //Read task to do read back
		if(mas.readdata!=reference_pat_rd[temp_address]) begin //Self Check 
			$display("Missmatch in Read, Address: %d,Read: %h,Expected Read: %h",i, mas.readdata, reference_pat_rd[i]);
			error_count = error_count + 1;	//counting number of mis-match
		end
	end

	if(error_count == 0)
		$display("Write after Read Full register set Test Verified!!");

	$stop;
end

endprogram : test
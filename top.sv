`timescale 1ns/1ps

//Module: Top
//Author: Mugilvanan Vinayagam
//Date  : 11/12/2018		

module top();
	logic clk = 1'b1;

	always #0.5 clk = ~clk;

	avalon_interface interfaces(clk);		//instantiate interfaces
	test mast(interfaces.master);		    //instantiate Master 
	avalon_slave sla(interfaces.slave);		//instantiate Slave	
endmodule
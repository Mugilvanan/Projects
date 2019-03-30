`timescale 1ns/1ps

//Module: Avalon_interface
//Author: Mugilvanan Vinayagam
//Date  : 11/12/2018	

interface avalon_interface(input logic clk);

	logic write;
	logic reset;
	logic read;
	logic waitrequest;
	logic [7:0] address;
	logic [7:0] writedata;
	logic [7:0] readdata;

	modport master(
		input         clk        , // Interface clock
		input         reset      , // Reset signal
		output    	  address    , // Register Address
		output        write      , // Register Write Strobe
		output        read       , // Register Read Strobe
		input         waitrequest, // Wait request
		output        writedata  , // Register Write Data
		input         readdata   , // Register Read Data
        import        write_mm   , //import write task
        import        read_mm    , //import read task
		import        reset_sys    //import reset task 
	);

	modport slave(
		input         clk        , // Interface clock
		input         reset      , // Reset signal
		input         address    , // Register Address
		input         write      , // Register Write Strobe
		input         read       , // Register Read Strobe
		output        waitrequest, // Wait request
		input         writedata  , // Register Write Data
		output        readdata     // Register Read Data
	);	

    // Reset task
	task reset_sys();
		reset = 1;
		$display("System reset! ");
		repeat(10) @(posedge clk);
		reset = 0;
	endtask : reset_sys
	//Master write task
    task write_mm(input logic [7:0] add, input logic[7:0] data);
    if(~waitrequest) //Wait for Waitrequest to be 0
    	write <= 1; //Write '1' and add, Data onto bus for a Clock
    	address = add;
    	writedata = data;
        $display("-------------------WRITE---------------------------");
    	$display("Write Initialted at Address :%d, with Data : 0x%h at %3d ns", address, writedata, $time);
    	@(posedge  clk) write <= 0; //Clear Write Strobe
    	@(negedge  waitrequest) //Wait for Slave to give ACK (Negedge waitrequest)
    	$display("Write Done");	
    	@(posedge  clk) //Delay (optional)
    	return;
    endtask : write_mm
    //Master task
    task read_mm(input logic[7:0] add);
    if(~waitrequest) //Wait for Waitrequest to be 0
    	read <= 1;  //Read '1' and add, Data onto bus for a Clock
    	address = add;
    	$display("-------------------READ----------------------------");
    	$display("Read Initialted at Address :%d at %3d ns", address, $time);		
    	@(posedge  clk) read <= 0; //Clear Read Strobe
    	@(negedge  waitrequest) //Wait for Slave to give ACK (Negedge waitrequest)
    	$display("Read Done, Read Data:0x%h at %3d ns", readdata, $time);		
    	//@(posedge  clk) //Delay (optional)
    	return;
    endtask : read_mm

endinterface : avalon_interface	
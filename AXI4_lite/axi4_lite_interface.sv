//***************************************************************************************
// MODULE : axi4_lite_interface
// AUTHOR : Mugilvanan Vinayagam
// DATE   : 11/18/2018
// DESCRIPTION
// -----------
//  This is a AXI4 Interface module that contains all AXI4_lite protocol signals for Master and Slave.
//
//***************************************************************************************

  parameter ADDRESS_WIDTH = 32;
  parameter REG_DATA_WIDTH = 32;

interface axi4_lite_interface(input axi4_lite_aclk, input axi4_lite_aresetn);

	// logic                             axi4_lite_aresetn              ;  // Active low reset
	logic  [(ADDRESS_WIDTH)-1:0]      axi4_lite_awaddr               ;  // Write Address signal
	logic                             axi4_lite_awvalid              ;  // Write Address Valid signal
	logic                             axi4_lite_awready              ;  // Write Address Ready signal
	logic  [REG_DATA_WIDTH-1   :0]    axi4_lite_wdata                ;  // Write data input
	logic                             axi4_lite_wvalid               ;  // Write data valid signal
	logic                             axi4_lite_wready               ;  // Write data Ready signal  
	logic                             axi4_lite_bready               ;  // Write Response Ready
	logic  [1:0]                      axi4_lite_bresp                ;  // Write Response Data  
	logic                             axi4_lite_bvalid               ;  // Write Response Valid 
	logic  [ADDRESS_WIDTH-1:0]        axi4_lite_araddr               ;  // Read Address signal  
	logic                             axi4_lite_arvalid              ;  // Read Address valid signal
	logic                             axi4_lite_arready              ;  // Read Address Ready signal 
	logic  [REG_DATA_WIDTH-1    :0]   axi4_lite_rdata                ;  // Read data Output  
	logic                             axi4_lite_rvalid               ;  // Read data valid signal
	logic  [1:0]                      axi4_lite_rresp                ;  // Read data response signal
	logic                             axi4_lite_rready               ;   // Read data Ready signal		

	modport master(
  		input  axi4_lite_aclk      ,  // System clock input
  		input  axi4_lite_aresetn   ,  // Active low reset
  		output  axi4_lite_awaddr    ,  // Write Address signal
  		output  axi4_lite_awvalid   ,  // Write Address Valid signal
  		input  	axi4_lite_awready   ,  // Write Address Ready signal
  		output  axi4_lite_wdata     ,  // Write data input
  		output  axi4_lite_wvalid    ,  // Write data valid signal
  		input   axi4_lite_wready    ,  // Write data Ready signal  
  		output  axi4_lite_bready    ,  // Write Response Ready
  		input   axi4_lite_bresp     ,  // Write Response Data  
  		input   axi4_lite_bvalid    ,  // Write Response Valid 
  		output  axi4_lite_araddr    ,  // Read Address signal  
  		output  axi4_lite_arvalid   ,  // Read Address valid signal
  		input   axi4_lite_arready   ,  // Read Address Ready signal 
  		input   axi4_lite_rdata     ,  // Read data Output  
  		input   axi4_lite_rvalid    ,  // Read data valid signal
  		input   axi4_lite_rresp     ,  // Read data response signal
  		output  axi4_lite_rready       // Read data Ready signal	
	);

	modport slave(
  		input   axi4_lite_aclk      ,  // System clock input
  		input   axi4_lite_aresetn   ,  // Active low reset
  		input   axi4_lite_awaddr    ,  // Write Address signal
  		input   axi4_lite_awvalid   ,  // Write Address Valid signal
  		output  axi4_lite_awready   ,  // Write Address Ready signal
  		input   axi4_lite_wdata     ,  // Write data input
  		input   axi4_lite_wvalid    ,  // Write data valid signal
  		output  axi4_lite_wready    ,  // Write data Ready signal  
  		input   axi4_lite_bready    ,  // Write Response Ready
  		output  axi4_lite_bresp     ,  // Write Response Data  
  		output  axi4_lite_bvalid    ,  // Write Response Valid 
  		input   axi4_lite_araddr    ,  // Read Address signal  
  		input   axi4_lite_arvalid   ,  // Read Address valid signal
  		output  axi4_lite_arready   ,  // Read Address Ready signal 
  		output  axi4_lite_rdata     ,  // Read data Output  
  		output  axi4_lite_rvalid    ,  // Read data valid signal
  		output  axi4_lite_rresp     ,  // Read data response signal
  		input   axi4_lite_rready       // Read data Ready signal	
	);	

endinterface : axi4_lite_interface
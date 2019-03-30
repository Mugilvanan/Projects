//***************************************************************************************
// MODULE : top
// AUTHOR : Mugilvanan Vinayagam
// DATE   : 11/22/2018
// DESCRIPTION
// -----------
//  This is a Top module that instantiates interface, master and slave modules. 
//
//***************************************************************************************
module top
	#(parameter ADDRESS_WIDTH           =32 ,    //Address pointer data width
	            REG_DATA_WIDTH          =32 ,     //Input data width and output data width
	            LEN_WIDTH				=5
	)
	(
	input  logic axi4_lite_aclk,
	input  logic axi4_lite_aresetn,
	input  logic WRITE,
	input  logic READ,
	input  logic DATA_VALID,
	input  logic [REG_DATA_WIDTH - 1 : 0] DATA_IN,
	input  logic [LEN_WIDTH - 1 : 0] DATA_LENGTH,
	input  logic [ADDRESS_WIDTH - 1 : 0] CPU_ADDR,
	output logic [REG_DATA_WIDTH - 1 : 0] DATA_OUT,
	output logic OUT_VALID,
	output logic BUSY,	
	output logic [LEN_WIDTH - 1 : 0]error_count
	);

	axi4_lite_interface axi4_lite(.axi4_lite_aclk, .axi4_lite_aresetn);
	axi4_lite_master M(.m1(axi4_lite.master), .*);
	axi4_lite_slave S(axi4_lite.slave);

endmodule // topend
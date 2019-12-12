// ----------------------------------------------------------------------------------
// -- Module Name  : AES_interface
// -- Project Name : Verification of AES GCM using systemverilog
// -- Engineer Name: Mugilvanan Vinayagam
// ----------------------------------------------------------------------------------

interface AES_interface (input clk);

	logic [63 : 0]data_in;		//64 bits input data
	logic [127 : 0]data_out;    //128 bits output data
	logic din_valid;            //data envelope for input data
	logic dout_valid;           //data envelope for output data
	logic En_Trig_in;           //trigger to start encryption/decryption
	logic [4 : 0]Mod_in;        //mode signal to select mode of encryption/decryption
	logic clk_out;              //slower clock generated based on the input clk
	logic reset;                //reset signal Asynchronous active high
	
	static int pre_count;
	static int ending;
	
	//modport to capture output data
	modport  return_AES(
		input  clk, 
		input  reset, 
		input  data_in, 
		output data_out, 
		input  din_valid, 
		output dout_valid, 
		input  En_Trig_in, 
		input  Mod_in, 
		output clk_out,
		import pre_count,
		import ending
		);

	//modport to send input data
	modport  assignment(
		input  clk, 
		input  reset, 
		output data_in, 
		input  data_out, 
		output din_valid, 
		input  dout_valid, 
		output En_Trig_in, 
		output Mod_in, 
		input  clk_out,
		import pre_count,
		import ending
		);

endinterface

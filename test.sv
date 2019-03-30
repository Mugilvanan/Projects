// ----------------------------------------------------------------------------------
// -- Module Name  : test
// -- Project Name : Verification of AES GCM using systemverilog
// -- Engineer Name: Mugilvanan Vinayagam
// ----------------------------------------------------------------------------------

program test(AES_interface.assignment input_stream,	AES_interface.return_AES out_stream);

	import env_inc :: *;							//importing package

	environment env;

	initial begin

		env = new(input_stream, out_stream);		//creating new object 
		env.build();								//calling build task
		env.execute();								//calling execute task
		repeat(50) @(posedge input_stream.clk);
		env.report();								//calling report task at end
		$stop;
	end

endprogram : test
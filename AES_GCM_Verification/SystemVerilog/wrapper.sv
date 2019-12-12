// ----------------------------------------------------------------------------------
// -- Module Name  : wrapper
// -- Project Name : Verification of AES GCM using systemverilog
// -- Engineer Name: Mugilvanan Vinayagam
// ----------------------------------------------------------------------------------


module wrapper(AES_interface.assignment AES);

	//Instantiation of VHDL module
	GCM_Validation DUV_AESGCM(
		.clk       ( AES.clk        ),
		.rst       ( AES.reset      ),
		.En_Trig_in( AES.En_Trig_in ),
        .Mod_in    ( AES.Mod_in     ),
        .din       ( AES.data_in    ),
        .din_dv    ( AES.din_valid  ),
        .dout      ( AES.data_out   ),
        .dout_v    ( AES.dout_valid ),
		.clk_out   ( AES.clk_out	)
		);
endmodule
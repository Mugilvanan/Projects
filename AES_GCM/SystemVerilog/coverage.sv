// ----------------------------------------------------------------------------------
// -- Module Name  : coverage
// -- Project Name : Verification of AES GCM using systemverilog
// -- Engineer Name: Mugilvanan Vinayagam
// ----------------------------------------------------------------------------------

class coverage;

	generator gen;
	mailbox #(generator) dri2cov;
	virtual AES_interface.return_AES AES_IF;

	covergroup cg with function sample(generator gen, virtual AES_interface.return_AES AES_IF);

		key_l : coverpoint gen.key_len { bins key_lens[] = { 128, 192, 256 }; }
		iv_l  : coverpoint gen.iv_len  { bins iv_lens[]  = { 96, 128 }; }	
		aad_l : coverpoint gen.aad_len { bins aad_llens[] = { 0, 128, 256 }; }
		data_l: coverpoint gen.data_len{ bins low   = { [1 : 255] };
										 bins med   = { [256 : 768]};
										 bins high  = { [769 : 1024]}; }
		modes : coverpoint gen.mode    { bins modes[] = { 10, 12, 14}; }								 
		lengths : cross key_l, iv_l, aad_l;	
		
	endgroup : cg

	function new(mailbox #(generator) dri2cov, virtual AES_interface.return_AES AES_IF);
		this.dri2cov = dri2cov;
		this.AES_IF  = AES_IF;
		this.cg = new;
	endfunction : new

	task sample_1();
		cg.sample(gen, AES_IF);
	endtask : sample_1
	
	
	task execute();
		wait(dri2cov.try_get(gen));
		//continue till number of operations is reached
		while(gen.AES_Enc_count < number_of_operations)
		begin
			if(gen.AES_Enc_count >= 15)					  //Sample only for random test cases 
				sample_1();
			repeat(50) @(posedge AES_IF.clk);
			wait(dri2cov.try_get(gen));                   //Waiting to capture next generated transaction
		end
	endtask : execute	

endclass : coverage

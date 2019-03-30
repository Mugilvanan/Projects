class monitor;

	generator gen;
	mailbox #(generator) dri2mon; 
	virtual AES_interface.return_AES AES_IF;

	function new(mailbox #(generator) dri2mon, virtual AES_interface.return_AES AES_IF);
		this.dri2mon = dri2mon;
		this.AES_IF  = AES_IF;
	endfunction : new

	task execute_1();
		wait(gen.encrypt_done.triggered);			//wait till encryption is done
		gen.AES_Enc_count++;
		if(gen.AES_Enc_count > 15) begin			//Only for random test cases
			wait(gen.decrypt_done.triggered);		//wait till decryption is done
			gen.AES_Dec_count++;
		end
	endtask : execute_1

	task execute();
	fork
	begin
		wait(dri2mon.try_get(gen));
		//continue till number of operations is reached
		while(gen.AES_Enc_count < number_of_operations)
		begin
			execute_1();
			repeat(50) @(posedge AES_IF.clk);
			wait(dri2mon.try_get(gen));        				//Waiting to capture next generated transaction 
		end
	end
	join
	endtask : execute	
	
	task report();

		$display("*************************************************************************");
		$display("Number of AES Encryption count             : %5d", gen.AES_Enc_count);
		$display("Number of AES Decryption count             : %5d", gen.AES_Dec_count);
		$display("Number of AES Successful Encryption count  : %5d", gen.S_AES_enc_cnt);
		$display("Number of AES Successful Decryption count  : %5d", gen.S_AES_dec_cnt);
		$display("Number of AES Unsuccessful Encryption count: %5d", gen.U_AES_enc_cnt);
		$display("Number of AES Unsuccessful Decryption count: %5d", gen.U_AES_dec_cnt);
		$display("*************************************************************************");

	endtask : report

endclass : monitor

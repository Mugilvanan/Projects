// ----------------------------------------------------------------------------------
// -- Module Name  : scoreboard
// -- Project Name : Verification of AES GCM using systemverilog
// -- Engineer Name: Mugilvanan Vinayagam
// ----------------------------------------------------------------------------------

class scoreboard;

	mailbox #(generator) dri2sb;
	generator gen;
	virtual AES_interface.return_AES AES_IF;

	function new(mailbox #(generator) dri2sb, virtual AES_interface.return_AES AES_IF);
		this.dri2sb = dri2sb;
		this.AES_IF  = AES_IF;
	endfunction : new

	task execute_pre();
	
		int count = 0;
		int count_target;
		int error_count = 0;
		logic [127 : 0] target;

		case(gen.AES_Enc_count)
			0, 5, 10: count_target = 1;
			1, 6, 11: count_target = 2;
			2, 3, 4, 7, 8, 9, 12, 13, 14: count_target = 5;
		endcase

		while(count < count_target)
		begin
			@(posedge AES_IF.clk_out);
			//Capture data_out when the data envelope is high and compare it with expected value.
			case(gen.AES_Enc_count)
				0: target = output_1_1[count];
				1: target = output_2_1[count];
				2: target = output_3_1[count];
				3: target = output_4_1[count];
				4: target = output_5_1[count];
				5: target = output_1_2[count];
				6: target = output_2_2[count];
				7: target = output_3_2[count];
				8: target = output_4_2[count];
				9: target = output_5_2[count];
				10: target = output_1_3[count];
				11: target = output_2_3[count];
				12: target = output_3_3[count];
				13: target = output_4_3[count];
				14: target = output_5_3[count];
			endcase
			if(AES_IF.dout_valid == 1)
			begin
				if(target != AES_IF.data_out) begin //Check for mismatch in output data
					$display("transaction Number: %d Mismatch: Data_expected: %16x Data_received: %16x", (gen.AES_Enc_count+1), target, AES_IF.data_out);	
					error_count = error_count + 1;
				end
				count = count + 1;
			end
		end

		if(error_count > 0) begin
			$display("Encryption Unsuccessfull");
			gen.U_AES_enc_cnt++;
		end else 
			gen.S_AES_enc_cnt++;

		//Trigger encrypt_done event
		->gen.encrypt_done;        


	endtask : execute_pre	
	
	task execute_ran();
		int iv_l;
		int aad_l;
		int count = 0;
		int error_count = 0;
		logic [127 : 0] data_in_encrypt[];


		iv_l  = (gen.iv_len >> 3);
		aad_l = (gen.aad_len >> 3);
		
		//Calling C reference model
		AES_GCM_encrypt(gen.key_len, iv_l, aad_l, gen.data_len, gen.key, gen.iv, gen.aad, gen.data_in);

		//read from the file created by C function
		$readmemh("encrypt.bin", data_in_encrypt);
		gen.word_len = data_in_encrypt.size();
				
		while(count < data_in_encrypt.size())
		begin
			@(posedge AES_IF.clk_out);
			//Capture data_out when the data envelope is high and compare it with expected value.
			if(AES_IF.dout_valid == 1)
			begin
				if(data_in_encrypt[count] != AES_IF.data_out) begin
					$display("Mismatch: Data_expected: %16x Data_received: %16x", data_in_encrypt[count], AES_IF.data_out);	
					error_count = error_count + 1;
				end
				gen.data_out[count] = AES_IF.data_out;
				count = count + 1;
			end
		end

		if(error_count > 0) begin
			$display("Encryption Unsuccessfull");
			gen.U_AES_enc_cnt++;
		end else 
			gen.S_AES_enc_cnt++;
		
		//Trigger encrypt_done event
		->gen.encrypt_done;        

		count = 0;
		while(count < data_in_encrypt.size())
		begin
			@(posedge AES_IF.clk_out);
			//Capture last data_out when the data envelope is high and check whether it is one. Design will return one as last data if decryption is successful.
			if(AES_IF.dout_valid == 1) begin
				count = count + 1;
				if(count == data_in_encrypt.size() && AES_IF.data_out == 128'h00000000000000000000000000000001) begin
					//$display("Decryption Successfull");
					gen.S_AES_dec_cnt++;
				end else if(count == data_in_encrypt.size() && AES_IF.data_out != 128'h00000000000000000000000000000001) begin 	
					$display("Decryption Unsuccessfull");
					gen.U_AES_dec_cnt++;
				end
			end
		end
		
		//Trigger decrypt_done event
		->gen.decrypt_done;		

	endtask : execute_ran
	
	task execute();
	fork
	begin
		wait(dri2sb.try_get(gen));
		while(gen.AES_Enc_count < number_of_operations)
		begin
			if(gen.AES_Enc_count >= 15)
				execute_ran();
			else
				execute_pre();
			repeat(50) @(posedge AES_IF.clk);
			wait(dri2sb.try_get(gen));
		end
		AES_IF.ending++;
		->gen.done;
	end
	join
	endtask : execute		

endclass : scoreboard	
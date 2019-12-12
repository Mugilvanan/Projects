// ----------------------------------------------------------------------------------
// -- Module Name  : bfm
// -- Project Name : Verification of AES GCM using systemverilog
// -- Engineer Name: Mugilvanan Vinayagam
// ----------------------------------------------------------------------------------

class bfm;

	mailbox #(generator) dri2bfm;
	virtual AES_interface.assignment AES_IF; 

	generator gen;

	function new(mailbox #(generator) dri2bfm, virtual AES_interface.assignment AES_IF);
		this.dri2bfm = dri2bfm;
		this.AES_IF  = AES_IF;
	endfunction : new

	//task to send key, iv, aad
	task execute_pre();
		logic [127 : 0] data_in_encrypt[];
		logic [4 : 0]zeros;

		//pre-generated test case counter - for doing coverage in Top module
		AES_IF.pre_count++;

		//Based on the test case countm, the BFM will send a particular test vector 
		case(gen.AES_Enc_count)
			0:
			begin
				AES_IF.Mod_in = 5'hA;
				
				for(int i = 0; i < 4; i++) begin
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_0_1[i][127 : 64];
					if(i < 1)
						AES_IF.En_Trig_in = 1'b1;
					else
						AES_IF.En_Trig_in = 1'b0;
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_0_1[i][63 : 0];
				end
				@(posedge AES_IF.clk) AES_IF.din_valid = 1'b0; AES_IF.data_in = 0;
			end
			1:
			begin
				AES_IF.Mod_in = 5'hA;
				
				for(int i = 0; i < 5; i++) begin
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_1_1[i][127 : 64];
					if(i < 1)
						AES_IF.En_Trig_in = 1'b1;
					else
						AES_IF.En_Trig_in = 1'b0;
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_1_1[i][63 : 0];
				end
				@(posedge AES_IF.clk) AES_IF.din_valid = 1'b0; AES_IF.data_in = 0;
			end	
			2:
			begin
				AES_IF.Mod_in = 5'hA;
				
				for(int i = 0; i < 8; i++) begin
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_2_1[i][127 : 64];
					if(i < 1)
						AES_IF.En_Trig_in = 1'b1;
					else
						AES_IF.En_Trig_in = 1'b0;
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_2_1[i][63 : 0];
				end
				@(posedge AES_IF.clk) AES_IF.din_valid = 1'b0; AES_IF.data_in = 0;
			end	
			3:
			begin
				AES_IF.Mod_in = 5'hA;
				
				for(int i = 0; i < 10; i++) begin
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_3_1[i][127 : 64];
					if(i < 1)
						AES_IF.En_Trig_in = 1'b1;
					else
						AES_IF.En_Trig_in = 1'b0;
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_3_1[i][63 : 0];
				end
				@(posedge AES_IF.clk) AES_IF.din_valid = 1'b0; AES_IF.data_in = 0;
			end	
			4:
			begin
				AES_IF.Mod_in = 5'hA;
				
				for(int i = 0; i < 10; i++) begin
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_4_1[i][127 : 64];
					if(i < 1)
						AES_IF.En_Trig_in = 1'b1;
					else
						AES_IF.En_Trig_in = 1'b0;
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_4_1[i][63 : 0];
				end
				@(posedge AES_IF.clk) AES_IF.din_valid = 1'b0; AES_IF.data_in = 0;
			end	
			5:
			begin
				AES_IF.Mod_in = 5'hC;
				
				for(int i = 0; i < 4; i++) begin
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_0_2[i][127 : 64];
					if(i < 1)
						AES_IF.En_Trig_in = 1'b1;
					else
						AES_IF.En_Trig_in = 1'b0;
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_0_2[i][63 : 0];
				end
				@(posedge AES_IF.clk) AES_IF.din_valid = 1'b0; AES_IF.data_in = 0;
			end
			6:
			begin
				AES_IF.Mod_in = 5'hC;
				
				for(int i = 0; i < 5; i++) begin
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_1_2[i][127 : 64];
					if(i < 1)
						AES_IF.En_Trig_in = 1'b1;
					else
						AES_IF.En_Trig_in = 1'b0;
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_1_2[i][63 : 0];
				end
				@(posedge AES_IF.clk) AES_IF.din_valid = 1'b0; AES_IF.data_in = 0;
			end	
			7:
			begin
				AES_IF.Mod_in = 5'hC;
				
				for(int i = 0; i < 8; i++) begin
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_2_2[i][127 : 64];
					if(i < 1)
						AES_IF.En_Trig_in = 1'b1;
					else
						AES_IF.En_Trig_in = 1'b0;
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_2_2[i][63 : 0];
				end
				@(posedge AES_IF.clk) AES_IF.din_valid = 1'b0; AES_IF.data_in = 0;
			end	
			8:
			begin
				AES_IF.Mod_in = 5'hC;
				
				for(int i = 0; i < 10; i++) begin
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_3_2[i][127 : 64];
					if(i < 1)
						AES_IF.En_Trig_in = 1'b1;
					else
						AES_IF.En_Trig_in = 1'b0;
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_3_2[i][63 : 0];
				end
				@(posedge AES_IF.clk) AES_IF.din_valid = 1'b0; AES_IF.data_in = 0;
			end	
			9:
			begin
				AES_IF.Mod_in = 5'hC;
				
				for(int i = 0; i < 10; i++) begin
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_4_2[i][127 : 64];
					if(i < 1)
						AES_IF.En_Trig_in = 1'b1;
					else
						AES_IF.En_Trig_in = 1'b0;
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_4_2[i][63 : 0];
				end
				@(posedge AES_IF.clk) AES_IF.din_valid = 1'b0; AES_IF.data_in = 0;
			end
			10:
			begin
				AES_IF.Mod_in = 5'hE;
				
				for(int i = 0; i < 4; i++) begin
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_0_3[i][127 : 64];
					if(i < 1)
						AES_IF.En_Trig_in = 1'b1;
					else
						AES_IF.En_Trig_in = 1'b0;
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_0_3[i][63 : 0];
				end
				@(posedge AES_IF.clk) AES_IF.din_valid = 1'b0; AES_IF.data_in = 0;
			end
			11:
			begin
				AES_IF.Mod_in = 5'hE;
				
				for(int i = 0; i < 5; i++) begin
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_1_3[i][127 : 64];
					if(i < 1)
						AES_IF.En_Trig_in = 1'b1;
					else
						AES_IF.En_Trig_in = 1'b0;
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_1_3[i][63 : 0];
				end
				@(posedge AES_IF.clk) AES_IF.din_valid = 1'b0; AES_IF.data_in = 0;
			end	
			12:
			begin
				AES_IF.Mod_in = 5'hE;
				
				for(int i = 0; i < 8; i++) begin
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_2_3[i][127 : 64];
					if(i < 1)
						AES_IF.En_Trig_in = 1'b1;
					else
						AES_IF.En_Trig_in = 1'b0;
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_2_3[i][63 : 0];
				end
				@(posedge AES_IF.clk) AES_IF.din_valid = 1'b0; AES_IF.data_in = 0;
			end	
			13:
			begin
				AES_IF.Mod_in = 5'hE;
				
				for(int i = 0; i < 10; i++) begin
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_3_3[i][127 : 64];
					if(i < 1)
						AES_IF.En_Trig_in = 1'b1;
					else
						AES_IF.En_Trig_in = 1'b0;
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_3_3[i][63 : 0];
				end
				@(posedge AES_IF.clk) AES_IF.din_valid = 1'b0; AES_IF.data_in = 0;
			end	
			14:
			begin
				AES_IF.Mod_in = 5'hE;
				
				for(int i = 0; i < 10; i++) begin
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_4_3[i][127 : 64];
					if(i < 1)
						AES_IF.En_Trig_in = 1'b1;
					else
						AES_IF.En_Trig_in = 1'b0;
					@(posedge AES_IF.clk) AES_IF.din_valid = 1'b1; AES_IF.data_in = test_vector_4_3[i][63 : 0];
				end
				@(posedge AES_IF.clk) AES_IF.din_valid = 1'b0; AES_IF.data_in = 0;
			end		
		endcase
		@(posedge AES_IF.clk) AES_IF.din_valid = 0;
		AES_IF.data_in = 0;

		//waiting for Encryption to get completed
		wait(gen.encrypt_done.triggered);
	endtask : execute_pre	

	task header(input logic [4 : 0] mode);
		logic [15 : 0]aad_words;
		logic [15 : 0]aad_bits;
		logic [15 : 0]iv_words;
		logic [15 : 0]iv_bits;
		AES_IF.Mod_in = mode;
		@(posedge AES_IF.clk);

		//Sending Key based on the key length
		if(gen.key_len == 128) begin
			AES_IF.din_valid = 1;
			AES_IF.En_Trig_in = 1;
			AES_IF.data_in = 0;
			@(posedge AES_IF.clk);
			@(posedge AES_IF.clk) AES_IF.En_Trig_in = 0; AES_IF.data_in = {>>{gen.key[0:7]}};
			@(posedge AES_IF.clk) AES_IF.En_Trig_in = 0; AES_IF.data_in = {>>{gen.key[8:15]}};
		end else if (gen.key_len == 192) begin
			AES_IF.din_valid = 1;
			AES_IF.En_Trig_in = 1;
			AES_IF.data_in = 0;
			@(posedge AES_IF.clk) AES_IF.En_Trig_in = 1; AES_IF.data_in = {>>{gen.key[0:7]}};
			@(posedge AES_IF.clk) AES_IF.En_Trig_in = 0; AES_IF.data_in = {>>{gen.key[8:15]}};
			@(posedge AES_IF.clk) AES_IF.En_Trig_in = 0; AES_IF.data_in = {>>{gen.key[16:23]}};
		end else begin	
			@(posedge AES_IF.clk) AES_IF.din_valid = 1; AES_IF.En_Trig_in = 1; AES_IF.data_in = {>>{gen.key[0:7]}};
			@(posedge AES_IF.clk) AES_IF.En_Trig_in = 1; AES_IF.data_in = {>>{gen.key[8:15]}};
			@(posedge AES_IF.clk) AES_IF.En_Trig_in = 0; AES_IF.data_in = {>>{gen.key[16:23]}};
			@(posedge AES_IF.clk) AES_IF.En_Trig_in = 0; AES_IF.data_in = {>>{gen.key[24:31]}};
		end
		//Sending data length in bits
		@(posedge AES_IF.clk) AES_IF.data_in = gen.data_len << 3;
				aad_bits  = gen.aad_len[15 : 0];
		iv_bits   = gen.iv_len[15 : 0];

		//converting iv and aad length from bits to 16 byte word
		aad_words = (gen.aad_len > 128) ? 2 : ((gen.aad_len > 0) ? 1 : 0);
		iv_words  = 1;
		@(posedge AES_IF.clk) AES_IF.data_in = {aad_words, iv_words, aad_bits, iv_bits};

		//Sending IV based on the length
		if(gen.iv_len == 96) begin
			@(posedge AES_IF.clk) AES_IF.data_in = {32'd0, {>>{gen.iv[0:3]}}};
			@(posedge AES_IF.clk) AES_IF.data_in = {>>{gen.iv[4:11]}};
		end else begin
			@(posedge AES_IF.clk) AES_IF.data_in = {>>{gen.iv[0:7]}};
			@(posedge AES_IF.clk) AES_IF.data_in = {>>{gen.iv[8:15]}};	
		end

		//Sending AAD based on the length
		if(aad_words == 2)begin
			@(posedge AES_IF.clk) AES_IF.data_in = {>>{gen.aad[0:7]}};
			@(posedge AES_IF.clk) AES_IF.data_in = {>>{gen.aad[8:15]}};
			@(posedge AES_IF.clk) AES_IF.data_in = {>>{gen.aad[16:23]}};
			@(posedge AES_IF.clk) AES_IF.data_in = {>>{gen.aad[24:31]}};
		end else if (aad_words == 1)begin 	
			@(posedge AES_IF.clk) AES_IF.data_in = {>>{gen.aad[0:7]}};
			@(posedge AES_IF.clk) AES_IF.data_in = {>>{gen.aad[8:15]}};
		end	
	endtask : header

	task execute_ran();
		logic [127 : 0] data_in_encrypt[];
		logic [4 : 0]zeros;
		int new_data_len;

		//Sending header for Encryption
		header(gen.mode);
		
		zeros = (gen.data_len[3 : 0] == 4'd0) ? 5'd0 : (5'd16 - {1'b0, gen.data_len[3 : 0]});
		new_data_len = gen.data_len + zeros;

		//Sending data as 8 byte words 
 		for(int i = 0; i < gen.data_len;)
		begin
			if((i+7) < gen.data_len)
				@(posedge AES_IF.clk) AES_IF.data_in = {gen.data_in[i], gen.data_in[i+1], gen.data_in[i+2], gen.data_in[i+3], gen.data_in[i+4], gen.data_in[i+5], gen.data_in[i+6], gen.data_in[i+7]};
			else begin
				@(posedge AES_IF.clk);
				//Appending zeros at the end if required
				case(zeros[2:0])
					3'b001: AES_IF.data_in = {gen.data_in[i], gen.data_in[i+1], gen.data_in[i+2], gen.data_in[i+3], gen.data_in[i+4], gen.data_in[i+5], gen.data_in[i+6], 8'd0};
					3'b010: AES_IF.data_in = {gen.data_in[i], gen.data_in[i+1], gen.data_in[i+2], gen.data_in[i+3], gen.data_in[i+4], gen.data_in[i+5], 16'd0};
					3'b011: AES_IF.data_in = {gen.data_in[i], gen.data_in[i+1], gen.data_in[i+2], gen.data_in[i+3], gen.data_in[i+4], 24'd0};
					3'b100: AES_IF.data_in = {gen.data_in[i], gen.data_in[i+1], gen.data_in[i+2], gen.data_in[i+3], 32'd0};
					3'b101: AES_IF.data_in = {gen.data_in[i], gen.data_in[i+1], gen.data_in[i+2], 40'd0};
					3'b110: AES_IF.data_in = {gen.data_in[i], gen.data_in[i+1], 48'd0};
					3'b111: AES_IF.data_in = {gen.data_in[i], 56'd0};
				endcase
			end
			i = i + 8;
		end

		if(zeros > 7)
			@(posedge AES_IF.clk) AES_IF.data_in = 0;
		@(posedge AES_IF.clk) AES_IF.din_valid = 0;
		AES_IF.data_in = 0;

		//waiting for Encryption to get completed
		wait(gen.encrypt_done.triggered);

		//Giving reset after encryption
		repeat(10) @(posedge AES_IF.clk);
		AES_IF.reset = 1;
		repeat(10) @(posedge AES_IF.clk);
		AES_IF.reset = 0;
		repeat(10) @(posedge AES_IF.clk);

		//Reading encrypted output from file
		$readmemh("encrypt.bin", data_in_encrypt);

		//Sending header for Decryption
		header((gen.mode + 1));

		//Sending data read from encrypted file
		for(int i; i < data_in_encrypt.size(); i++)
		begin
		`ifdef INJECT_ERROR
			if(gen.inject == 1 && gen.index  == i ) begin									//Error Injection logic
				@(posedge AES_IF.clk) AES_IF.data_in = 0;
				@(posedge AES_IF.clk) AES_IF.data_in = {32'd0, $urandom};
			end else begin
				@(posedge AES_IF.clk) AES_IF.data_in = data_in_encrypt[i][127 : 64];
				@(posedge AES_IF.clk) AES_IF.data_in = data_in_encrypt[i][63 : 0];		
			end
		`else
			@(posedge AES_IF.clk) AES_IF.data_in = data_in_encrypt[i][127 : 64];
			@(posedge AES_IF.clk) AES_IF.data_in = data_in_encrypt[i][63 : 0];	
		`endif
		end
		@(posedge AES_IF.clk) AES_IF.din_valid = 0;
		AES_IF.data_in = 0;

		//waiting for Decryption to get completed
		wait(gen.decrypt_done.triggered);

	endtask : execute_ran
	
	task execute();
		fork 
		begin
		wait(dri2bfm.try_get(gen));
		//continue till number of operations is reached
		while(gen.AES_Enc_count < number_of_operations)
		begin
			if(gen.AES_Enc_count >= 15)						//Since 15 pre-generated test cases
				execute_ran();								//Random test cases
			else 
				execute_pre();								//Pre-generated test cases
			repeat(50) @(posedge AES_IF.clk);
			wait(dri2bfm.try_get(gen));        				//Waiting to capture next generated transaction           
		end
		end
		join
	endtask : execute

endclass : bfm 

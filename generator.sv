// ----------------------------------------------------------------------------------
// -- Module Name  : generator
// -- Project Name : Verification of AES GCM using systemverilog
// -- Engineer Name: Mugilvanan Vinayagam
// ----------------------------------------------------------------------------------

class generator;

	//Random values to be generated
	rand byte unsigned key[];
	rand byte unsigned iv[];
	rand byte unsigned aad[];
	rand byte unsigned data_in[];
	rand int  unsigned key_len;
	rand int  unsigned iv_len;
	rand int  unsigned aad_len;
	rand int  unsigned data_len;
	rand logic [4 : 0] mode;
	rand int index;
	rand logic inject;	

	logic [127 : 0] data_out[4001];
	event encrypt_done;
	event decrypt_done;
	event done;
	logic [15 : 0] len_64;
	logic [15 : 0] len_128;
	int word_len;

	//Static variables to keep track of the statistics
	static int AES_Enc_count = 0;
    static int AES_Dec_count = 0;
    static int S_AES_enc_cnt = 0;
	static int S_AES_dec_cnt = 0;
    static int U_AES_enc_cnt = 0;
    static int U_AES_dec_cnt = 0;


	enum logic [4 : 0] {ENC_128 = 10, DEC_128, ENC_192, DEC_192, ENC_256, DEC_256}modes;

	//Constraint to the random variables
	constraint  mode_in    { mode 	  inside{10, 12, 14};}
	constraint  IV_length  { iv_len   inside{96, 128};               }
	constraint  Key_length { (key_len == 128 && mode == 10) || (key_len == 192 && mode == 12) || (key_len == 256 && mode == 14);  }
	constraint  aad_length { aad_len  inside{0, 128, 256};           }
	constraint  data_length{ data_len inside{[1 : 1024]};            }
	constraint  key_input  { key.size()     == (key_len >> 3); 		 }
	constraint  iv_input   { iv.size()      == (iv_len >> 3);  		 }
	constraint  aad_input  { aad.size()     == (aad_len >> 3); 		 }
	constraint  data_input { data_in.size() == data_len;     		 }
	constraint index_value { index < (data_len >> 4); }
	constraint inject_value{ inject dist {0 :=40, 1 :=1}; }

	//Function to write a ta=ransaction in a log file object
function void log_file(int fd);
		$fdisplay(fd, "\n******************************************************************************");
		$fdisplay(fd, "Transaction: %d", AES_Enc_count);
		$fwrite(fd, "Key_length: %d", key_len);
		$fwrite(fd, "\tkey: ");
		for(int i = 0; i < key.size(); i++)
			$fwrite(fd, "%02x", key[i]);
		$fwrite(fd, "\niv_length: %d", iv_len);
		$fwrite(fd, "\tiv: ");
		for(int i = 0; i < iv.size(); i++)
			$fwrite(fd, "%02x", iv[i]);
		$fwrite(fd, "\naad_length: %d", aad_len);
		if(aad_len > 0) begin
			$fwrite(fd, "\taad: ");
			for(int i = 0; i < aad.size(); i++)
				$fwrite(fd, "%02x", aad[i]);
		end
		$fwrite(fd, "\ndata_length: %d", data_len);
		$fwrite(fd, "\ndata_in: ");
		for(int i = 0; i < data_in.size(); i++) begin
			if(i%16 == 0)
				$fdisplay(fd, "");
			$fwrite(fd, "%02x", data_in[i]);
		end	
		$fdisplay(fd, "\ndata_out: ");
		for(int i = 0; i < word_len; i++) begin
			$fdisplay(fd, "%32x", data_out[i]);
		end					
		$fdisplay(fd, "*******************************************************************************\n");		
	endfunction : log_file	

endclass : generator

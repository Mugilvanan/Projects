// ----------------------------------------------------------------------------------
// -- Module Name  : top
// -- Project Name : Verification of AES GCM using systemverilog
// -- Engineer Name: Mugilvanan Vinayagam
// ----------------------------------------------------------------------------------


module top;

	logic clk = 1;
	
	always #5 clk = ~clk;
	
	import env_inc :: *;


	//type state is(Idle,Get_Key,Get_Data,En_Encrypt,En_Encrypt1,Get_HData,Get_HData1,check_A,cal_Jo,cal_Ek,Pad_len,Pad_len_wt,wait_St,wait_st2,wait_st21,Tag_Check);
 	
 	class coverage_module;
	covergroup cg_1();
		//Coverage of states
		states : coverpoint DUV.DUV_AESGCM.U0.n_st { bins all_states[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}; } 
	   	
		//Coverage of state transitions
	   	state : coverpoint DUV.DUV_AESGCM.U0.n_st { bins states_1 = (0 => 1); 
													bins states_2 = (1 => 5); 
													bins states_3 = (1 => 1); 
													bins states_4 = (5 => 8); 
													bins states_5 = (5 => 5); 
													bins states_6 = (8 => 7); 
													bins states_7 = (7 => 9);
													bins states_8 = (9 => 9);
													bins states_9 = (9 => 10);
													bins states_10 = (10 => 12);
													bins states_11 = (12 => 0);
													bins states_12 = (12 => 15);
													bins states_13 = (9 => 11);
													bins states_14 = (11 => 10);}

		//Coverage of modes
		modes : coverpoint AES_IF.Mod_in { bins modes_1[] = {10, 11, 12, 13, 14, 15}; }

		//Coverage of mode transitions
		modes_t : coverpoint AES_IF.Mod_in{ bins modes_2 = (10 => 11);
													  bins modes_3 = (11 => 12);
													  bins modes_4 = (12 => 13);
													  bins modes_5 = (13 => 14);
													  bins modes_6 = (14 => 15);
													  bins modes_7 = (10 => 12);
													  bins modes_8 = (12 => 14);
													  bins modes_9 = (15 => 10);
													  bins modes_10 = (15 => 12);
													  bins modes_11 = (15 => 14); }
		
		//Cross coverage of modes and state transitions										  
        mode_state : cross modes, state {	ignore_bins encrypt_state1 = (binsof(modes.modes_1[10]) || binsof(modes.modes_1[12]) || binsof(modes.modes_1[14])) && (binsof(state.states_12) || binsof(state.states_13) || binsof(state.states_14));
											ignore_bins decrypt_state1 = (binsof(modes.modes_1[11]) || binsof(modes.modes_1[13]) || binsof(modes.modes_1[15])) && (binsof(state.states_10) || binsof(state.states_9) || binsof(state.states_11)); }
		
		//Coverage of test case count
		pre_det_count : coverpoint AES_IF.pre_count { bins values[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}; }
		
		//Coverage of internediate values
		H_values : coverpoint DUV.DUV_AESGCM.U0.H {bins valid_H[6] = { 128'h66e94bd4ef8a2c3b884cfa59ca342b2e,
					  128'hb83b533708bf535d0aa6e52980d53b78,
					  128'haae06992acbf52a3e8f4a96ec9300bd7,
					  128'h466923ec9ae682214f2c082badb39249,
					  128'hdc95c078a2408989ad48a21492842087,
					  128'hacbef20579b4b8ebce889bac8732dad7
					};	}	
		
		Ek_values : coverpoint DUV.DUV_AESGCM.U0.Jo_Ek {bins valid_Ek[9] = { 128'h58e2fccefa7e3061367f1d57a4e7455a,
                      128'h3247184b3c4f69a44dbcd22887bbb418,
                      128'he94ab9535c72bea9e089c93d48e62fb0,
                      128'hcd33b28ac773f74ba00ed1f312572435,
                      128'hc835aa88aebbc94f5a02e179fdcfc3e4,
                      128'h7bb6d647c902427ce7cf26563a337371,
                      128'h530f8afbc74536b9a963b4f1c4cb738b,
                      128'hfd2caa16a5832e76aa132c1453eeda7e,
                      128'h4f903f37fe611d454217fbfa5cd7d791
                    }; }
		
		//Cross cover of test case count and corresponding internediate values 			
		count_H : cross H_values, pre_det_count { bins c_H = (binsof(pre_det_count.values[1]) || binsof(pre_det_count.values[2])) && binsof(H_values.valid_H[0]);
											  bins cH1 = (binsof(pre_det_count.values[3]) || binsof(pre_det_count.values[4]) || binsof(pre_det_count.values[5])) && binsof(H_values.valid_H[1]);
											  bins cH2 = (binsof(pre_det_count.values[6]) || binsof(pre_det_count.values[7])) && binsof(H_values.valid_H[2]);
											  bins cH3 = (binsof(pre_det_count.values[8]) || binsof(pre_det_count.values[9]) || binsof(pre_det_count.values[10])) && binsof(H_values.valid_H[3]);	
											  bins cH4 = (binsof(pre_det_count.values[11]) || binsof(pre_det_count.values[12])) && binsof(H_values.valid_H[4]);
											  bins cH5 = (binsof(pre_det_count.values[13]) || binsof(pre_det_count.values[14]) || binsof(pre_det_count.values[15])) && binsof(H_values.valid_H[5]); }
		
		count_Ek: cross Ek_values, pre_det_count{ bins c_E = (binsof(pre_det_count.values[1]) || binsof(pre_det_count.values[2])) && !binsof(Ek_values.valid_Ek[0]);
											  bins cE1 =	(binsof(pre_det_count.values[3]) || binsof(pre_det_count.values[4])) && !binsof(Ek_values.valid_Ek[1]);
											  bins cE2 =	binsof(pre_det_count.values[5]) && !binsof(Ek_values.valid_Ek[2]);
											  bins cE3 =	(binsof(pre_det_count.values[6]) || binsof(pre_det_count.values[7])) && !binsof(Ek_values.valid_Ek[3]);
											  bins cE4 = (binsof(pre_det_count.values[8]) || binsof(pre_det_count.values[9])) && !binsof(Ek_values.valid_Ek[4]);
											  bins cE5 =	binsof(pre_det_count.values[10]) && !binsof(Ek_values.valid_Ek[5]);
											  bins cE6 =	(binsof(pre_det_count.values[11]) || binsof(pre_det_count.values[12])) && !binsof(Ek_values.valid_Ek[6]);
											  bins cE7 =	(binsof(pre_det_count.values[12]) || binsof(pre_det_count.values[14])) && !binsof(Ek_values.valid_Ek[7]);
											  bins cE8 =	binsof(pre_det_count.values[15]) && !binsof(Ek_values.valid_Ek[8]); }
																
		endings : coverpoint AES_IF.ending { bins ones = {1}; }
	endgroup : cg_1
	
	function new();
		cg_1 = new;
	endfunction : new
	
	task sample_1();
		fork
		do
		begin
			cg_1.sample();				//Sample every posedge of clock 
			@(posedge clk);
		end
		while(cg_1.get_coverage() < 100); //Run in background till 100% coverage is achieved or the stop command for simulation is given			
		join_none
	endtask : sample_1
	endclass : coverage_module

	coverage_module cov_1;
		
	initial begin
		cov_1 = new();			//new object for coverage
		cov_1.sample_1();		//sample function
	end 

	AES_interface AES_IF(.clk);							//Instantiation of AES inteface
	wrapper DUV(AES_IF.assignment);						//Instantiation of Wrapper module which contains target design instance
	test test(AES_IF.assignment, AES_IF.return_AES);	//Instantiation of program block which starts the environment
	
endmodule
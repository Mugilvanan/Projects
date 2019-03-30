// ----------------------------------------------------------------------------------
// -- Module Name  : driver
// -- Project Name : Verification of AES GCM using systemverilog
// -- Engineer Name: Mugilvanan Vinayagam
// ----------------------------------------------------------------------------------

class driver;

generator gen;

mailbox #(generator) dri2sb;
mailbox #(generator) dri2bfm;
mailbox #(generator) dri2mon;
mailbox #(generator) dri2cov;
virtual AES_interface.assignment AES_IF;

function new(mailbox #(generator) dri2sb, mailbox #(generator) dri2bfm, mailbox #(generator) dri2mon, mailbox #(generator) dri2cov, virtual AES_interface.assignment AES_IF);
	this.dri2sb  = dri2sb;
	this.dri2bfm = dri2bfm;
	this.dri2mon = dri2mon;
	this.dri2cov = dri2cov;
	this.AES_IF = AES_IF;
endfunction : new

task execute();
	fork 
	begin
		int fd;
		fd = $fopen("transactions.log", "w");		
		AES_IF.reset = 1;
		repeat(50) @(posedge AES_IF.clk);
		for(int i = 0; i <= number_of_operations; i++)
		begin
			AES_IF.reset = 0;
			repeat(5) @(posedge AES_IF.clk);
			gen = new();
			if(gen.AES_Enc_count >= 15) begin   //Randomize after crossing pre-generated test cases
				assert(gen.randomize());
			end
			dri2sb.put(gen);					//Passing generator handle to different components
			dri2bfm.put(gen);
			dri2mon.put(gen);
			dri2cov.put(gen);
			if(i < number_of_operations && gen.AES_Enc_count >= 15)     //Both encryption and decryption are done in random cases
				wait(gen.decrypt_done.triggered);
			else if(i < number_of_operations && gen.AES_Enc_count < 15) //Only encryption is done in pre-generated test cases
				wait(gen.encrypt_done.triggered);
			else if(i == number_of_operations) 							//Waiting for done event in last transaction
				wait(gen.done.triggered);	
			`ifdef DEBUG
				if(i < number_of_operations && gen.AES_Enc_count > 15) gen.log_file(fd);  //log file if the debug option is given
			`endif
			repeat(5) @(posedge AES_IF.clk);
			AES_IF.reset = 1;
			repeat(5) @(posedge AES_IF.clk);
		end
	end
	join
endtask : execute

endclass : driver	
	
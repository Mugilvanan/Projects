// ----------------------------------------------------------------------------------
// -- Module Name  : environment
// -- Project Name : Verification of AES GCM using systemverilog
// -- Engineer Name: Mugilvanan Vinayagam
// ----------------------------------------------------------------------------------

class environment;

	//mailboxes to transfer generator object around the environment 
	mailbox #(generator) dri2sb  = new();
	mailbox #(generator) dri2bfm = new();
	mailbox #(generator) dri2mon = new();
	mailbox #(generator) dri2cov = new();

	virtual AES_interface.assignment input_stream;
	virtual AES_interface.return_AES out_stream;

	driver dr;
	scoreboard sb;
	bfm b;
	monitor mon;
	coverage cov;

	function new(virtual AES_interface.assignment input_stream, virtual AES_interface.return_AES out_stream);
		this.input_stream = input_stream;
		this.out_stream   = out_stream;
	endfunction : new

	task build();
		dr = new(dri2sb, dri2bfm, dri2mon, dri2cov, input_stream);
		sb = new(dri2sb, out_stream);
		b  = new(dri2bfm, input_stream);
		mon = new(dri2mon, out_stream);
		cov = new(dri2cov, out_stream);		
	endtask : build

	task execute();         //all the tasks run parallelly
		fork
			dr.execute();
			b.execute();
			sb.execute();
			mon.execute();
			cov.execute();			
		join
	endtask : execute

	task report();		
		mon.report();
	endtask : report	

endclass : environment



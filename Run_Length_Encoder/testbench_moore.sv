`timescale 1ns/100ps

module testbench_moore();

time CLOCK_PERIOD = 6.4;          // Frequency = 156.25MHz => CLOCK_PERIOD = 1/(156.25x10^(-6)) = 6.4 ns

typedef struct packed {
	logic [7:0] data;
	logic valid;	
}out_st;

logic clock = 1'b1;
logic reset_n = 1'b0;
logic [6:0] dataIn = 7'd0;
out_st dataOut;

runLengthEncoder_moore DUT (.clock(clock), .reset_n(reset_n), .dataIn(dataIn), .dataOut(dataOut));

always #(CLOCK_PERIOD/2) clock = ~clock;

initial begin
	@(posedge clock) dataIn = 7'd0;
	#15 reset_n = 1'b1;
	@(posedge clock) dataIn = 7'd55;
	repeat(3) @(posedge clock) dataIn = 7'd75;          // repeats same value 3 times
	repeat(1) @(posedge clock) dataIn = 7'd28;
	repeat(5) @(posedge clock) dataIn = 7'd14;			// repeats same value 5 times
	repeat(4) @(posedge clock) dataIn = 7'd23;			// repeats same value 4 times
	repeat(1) @(posedge clock) dataIn = 7'd122;
	repeat(270) @(posedge clock) dataIn = 7'd08;		// repeats same value 270 times
	repeat(2) @(posedge clock) dataIn = 7'd111;			// repeats same value 2 times
	repeat(3) @(posedge clock) dataIn = 7'd65;			// repeats same value 3 times
	repeat(1) @(posedge clock) dataIn = 7'd88;
	repeat(23) @(posedge clock) dataIn = 7'd44;			// repeats same value 23 times
	repeat(4) @(posedge clock) dataIn = 7'd03;			// repeats same value 4 times
	repeat(10) @(posedge clock) dataIn = 7'd0;			// white spaces before end
	repeat(1) @(posedge clock) reset_n = 1'b0;
	$stop;
end // initial

initial 
	$monitor("time = %3d, dataIn = %2x, indication = %1b, dataOut = %2x, valid = %1b, data_struct = %2x %1b, count = %3d,  State = %s", $time, dataIn, dataOut.data[7], {1'b0, dataOut.data[6:0]}, dataOut.valid, dataOut.data, dataOut.valid, DUT.count, DUT.State.name());
 endmodule

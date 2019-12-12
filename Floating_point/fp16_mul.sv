// ---------------------------------------------------------------------------------------
// -- Module Name  : fp16_add
// -- Engineer Name: Mugilvanan Vinayagam
// -- Description  : Systemverilog implementation of floating point 16-bit multiplication.
// ---------------------------------------------------------------------------------------

module fp16_mul(
	input logic clk,
	input logic rst,
	input logic [15 : 0] in1,
	input logic [15 : 0] in2,
	output logic [15 : 0] mul
	);

logic sign_1, sign_2, sign_out;
logic [4 : 0]exp1, exp2, exp_out, act_expo;
logic [10 : 0]mant1, mant2;
logic [21 : 0]mant_out;
logic [9 : 0]act_mant; 

always_comb
begin
	sign_1 = in1[15];
	sign_2 = in2[15];
	exp1   = in1[14:10] - 15;
	exp2   = in2[14:10] - 15;
	mant1  = {1'b1, in1[9 : 0]};
	mant2  = {1'b1, in2[9 : 0]};
	act_mant = (mant_out[21]) ? mant_out[20:11] : mant_out[19:10];
	act_expo = (mant_out[21]) ? exp_out + 16 : exp_out + 15;
	mul    = {sign_out, act_expo, act_mant};
end

always_ff @(posedge clk)
begin
	if (rst)
	begin
		// mul <= 0;
		sign_out <= 0;
		exp_out <= 0;
		mant_out <= 0;
	end
	else
	begin
		sign_out <= sign_1 ^ sign_2;
		exp_out <= exp1 + exp2;
		mant_out <= mant1 * mant2;
	end
end

endmodule // fp16_mul

module mul_tb();

	logic clk = 1;
	logic rst = 1;
	logic [15 : 0] in1 = 0;
	logic [15 : 0] in2 = 0;
	logic [15 : 0] mul;

	fp16_mul DUT(.*);

	always #5 clk = ~clk;

	initial
	begin
		repeat(5) @(posedge clk);
		rst = 0;
		@(posedge clk) in1 = 16'h6702; in2 = 16'hf4cc;
		@(posedge clk) in1 = 16'h0; in2 = 16'h0;
	end

	initial
		$monitor("%x %x %x", in1, in2, mul);

endmodule		
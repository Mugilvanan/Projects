// ----------------------------------------------------------------------------------
// -- Module Name  : fp16_add
// -- Engineer Name: Mugilvanan Vinayagam
// -- Description  : Systemverilog implementation of floating point 16-bit addition.
// ----------------------------------------------------------------------------------

module fp16_add(
	input logic clk,
	input logic rst,
	input logic [15 : 0] in1,
	input logic [15 : 0] in2,
	output logic [15 : 0] mul
	);

logic sign_1, sign_2, sign_out;
signed logic [4 : 0]exp1, exp2, exp_out, act_expo, exp_diff;
logic [11 : 0]mant1, mant2;
logic [11 : 0]mant_out;
logic [9 : 0]act_mant; 

always_comb
begin
	sign_1 = in1[15];
	sign_2 = in2[15];
	exp1   = in1[14:10] - 15;
	exp2   = in2[14:10] - 15;
	if (exp1 > exp2)
	begin
		exp_diff = exp1 - exp2
		mant2 = {2'b01, in2[9 : 0]} >> exp_diff;
		mant1 = {2'b01, in1[9 : 0]};
		// exp_out = exp1;
	end
	else if (exp2 > exp1)
	begin
		exp_diff = exp2 - exp1
		mant1 = {2'b01, in1[9 : 0]} >> exp_diff;
		mant2 = {2'b01, in2[9 : 0]};
		// exp_out = exp2;
	end	
	else
	begin	
		mant2  = {2'b01, in2[9 : 0]};
		mant1  = {2'b01, in1[9 : 0]};
		// exp_out = exp1;
	end
	if((mant_out & 12'b111111111111) == 12'b000000000001)
	begin
		act_mant = 10'b0;
		act_expo = exp_out + 5;
	end
	else if((mant_out & 12'b111111111110) == 12'b000000000010)
	begin
		act_expo = exp_out + 6;
		act_mant = {mant_out[0], 9'b0};
	end
	else if((mant_out & 12'b111111111100) == 12'b000000000100)
	begin
		act_expo = exp_out + 7;
		act_mant = {mant_out[1:0], 8'b0};
	end	
	else if((mant_out & 12'b111111111000) == 12'b000000001000)
	begin
		act_expo = exp_out + 8;
		act_mant = {mant_out[2:0], 7'b0};
	end	
	else if((mant_out & 12'b111111110000) == 12'b000000010000)
	begin
		act_expo = exp_out + 9;
		act_mant = {mant_out[3:0], 6'b0};
	end			
	else if((mant_out & 12'b111111100000) == 12'b000000100000)
	begin
		act_expo = exp_out + 10;
		act_mant = {mant_out[4:0], 5'b0};
	end	
	else if((mant_out & 12'b111111000000) == 12'b000001000000)
	begin
		act_expo = exp_out + 11;
		act_mant = {mant_out[5:0], 4'b0};
	end	
	else if((mant_out & 12'b111110000000) == 12'b000010000000)
	begin
		act_expo = exp_out + 12;
		act_mant = {mant_out[6:0], 3'b0};
	end	
	else if((mant_out & 12'b111100000000) == 12'b000100000000)
	begin
		act_expo = exp_out + 13;
		act_mant = {mant_out[7:0], 2'b0};
	end		
	else if((mant_out & 12'b111000000000) == 12'b001000000000)
	begin
		act_expo = exp_out + 14;
		act_mant = {mant_out[8:0], 1'b0};
	end							
	else if((mant_out & 12'b110000000000) == 12'b010000000000)
	begin
		act_expo = exp_out + 15;
		act_mant = mant_out[9:0];
	end
	else
	begin
		act_expo = exp_out + 16;
		act_mant = mant_out[10:1];
	end			
	mul = {sign_out, act_expo, act_mant};
end

always_ff @(posedge clk)
begin
	if (rst)
	begin
		mul <= 0;
		sign_out <= 0;
		exp_out <= 0;
		mant_out <= 0;
	end
	else
	begin
		// sign_out <= (sign_1 & sign_2) | (sign_1 & (exp1 > exp2)) | (sign_2 & (exp2 > exp1));
		exp_out <= (exp1 >= exp2) ? exp1 : exp2; 
		if(sign_1 == sign_2)
		begin
			sign_out <= (sign_1 & sign_2);
			mant_out <= mant1 + mant2;
		end
		else if(sign_1 & (exp1 > exp2))
		begin
			sign_out <= sign_1;
			mant_out <= mant1 - mant2;
		end
		else if(sign_1 & (exp2 > exp1))
		begin
			sign_out <= sign_2;
			mant_out <= mant2 - mant1;
		end
		else if(sign_2 & (exp1 > exp2))
		begin
			sign_out <= sign_1;
			mant_out <= mant1 - mant2;
		end
		else if(sign_2 & (exp2 > exp1))
		begin
			sign_out <= sign_2;
			mant_out <= mant2 - mant1;
		end
		else if(exp1 == exp2)
		begin
			if(sign_1 & (mant1 > mant2))
			begin
				sign_out = sign_1;
				mant_out <= mant1 - mant2;
			end
			else if (sign_1 & mant2 > mant1)
			begin
				sign_out = sign_2;
				mant_out <= mant2 - mant1;
			end				
			if(sign_2 & (mant1 > mant2))
			begin
				sign_out = sign_1;
				mant_out <= mant1 - mant2;
			end
			else if (sign_2 & mant2 > mant1)
			begin
				sign_out = sign_2;
				mant_out <= mant2 - mant1;
			end
		end				

	end
end

endmodule // fp16_mul
module Convolution_3d(
    input clk,
    input reset,
    input [11:0] in_pixel,
    output logic [18:0] ram_addr,
    output logic out_pixel,
    output logic [18:0] out_addr_temp,
    output logic out_wr,
    input [9:0] fil_sel
    );

logic signed [8 : 0] filter_1[1 : 9] = {-1, -1, -1, 0, 0, 0, 1, 1, 1};
logic signed [8 : 0] filter_2[1 : 9] = {-1, 0, 1, -1, 0, 1, -1, 0, 1};
logic signed [8 : 0] filter_3[1 : 9] = {-1, -1, 0, -1, 0, 1, 0, 1, 1};
logic signed [8 : 0] filter_4[1 : 9] = {0, -1, -1, 1, 0, -1, 1, 1, 0};
logic signed [8 : 0] filter_5[1 : 9] = {-1, -2, -1, 0, 0, 0, 1, 2, 1};
logic signed [8 : 0] filter_6[1 : 9] = {-1, 0, 1, -2, 0, 2, -1, 0, 1};
logic signed [8 : 0] filter_7[1 : 9] = {-2, -1, 0, -1, 0, 1, 0, 1, 2};
logic signed [8 : 0] filter_8[1 : 9] = {0, -1, -2, 1, 0, -1, 2, 1, 0};
logic signed [8 : 0] filter_9[1 : 9] = {0, -1, 0, -1, 4, -1, 0, -1, 0};
logic signed [8 : 0] filter_10[1 : 9] = {-1, -1, -1, -1, 8, -1, -1, -1, -1};

logic [3 : 0] count, count1;
logic [9 : 0] count_637, count_637_1;
logic signed [8 : 0] pro_R, pro_G, pro_B;
logic signed [8 : 0] sum_R, sum_G, sum_B;

logic out_pix;
logic out_wr_temp;
logic [18 : 0]out_addr;

logic signed [9 : 0] filter;


always_comb begin
    case(fil_sel)
        10'b0000000001: filter = filter_1[count];
        10'b0000000010: filter = filter_2[count];
        10'b0000000100: filter = filter_3[count];
        10'b0000001000: filter = filter_4[count];
        10'b0000010000: filter = filter_5[count];
        10'b0000100000: filter = filter_6[count];
        10'b0001000000: filter = filter_7[count];
        10'b0010000000: filter = filter_8[count];
        10'b0100000000: filter = filter_9[count];
        10'b1000000000: filter = filter_10[count];
        default:        filter = filter_9[count];
    endcase
end

always_ff @(posedge clk) begin
    out_addr_temp <= out_addr;
    out_wr <= out_wr_temp;
    out_pixel <= out_pix;
end
                        
always_ff @(posedge clk) begin
    if(reset == 1'b1)
        count <= 0;
    else if(count < 9)
        count <= count + 1;
    else
        count <= 1;        
    count1 <= count;
end

always_ff @(posedge clk) begin

    if(reset == 1'b1) begin
        ram_addr <= 0;
        count_637_1 <= 0; 
        out_addr <= 0;
        pro_R <= 0;
        pro_G <= 0;
        pro_B <= 0;
    end else begin
    if(ram_addr >= 307199)
        ram_addr <= 0;
    else begin
        if(count == 2 || count == 5)
            ram_addr <= ram_addr + 638;
        else if(count == 8 && count_637_1 < 637)
            ram_addr <= ram_addr - 1281;
        else if(count == 8 && count_637_1 == 637)
            ram_addr <= ram_addr - 1279;            
        else
            ram_addr <= ram_addr + 1;
    end 
        
    if(count_637 == 637)
        count_637 <= 0;
    else
        count_637 <= count_637 + 1;
    
    if((count_637_1 == 637 && count == 1))
        count_637_1 <= 0;
    else if(count1 > 0 && count == 1)
        count_637_1 <= count_637_1 + 1;
    else
        count_637_1 <= count_637_1;    
        
    if(out_addr >= 305917  && count == 1)
        out_addr <= 0;
    else if(count1 > 0 && count == 1) begin
        if(count_637_1 == 637) 
            out_addr <= out_addr + 3;
        else
            out_addr <= out_addr + 1; 
    end else
        out_addr <= out_addr;
                    
    if(count > 0) begin
//            pro_R <= filter[count] * {5'b0, in_pixel[11 : 8]};
//            pro_G <= filter[count] * {5'b0, in_pixel[7 : 4]};
//            pro_B <= filter[count] * {5'b0, in_pixel[3 : 0]};
         case(filter)
   9'b111111111: begin
           pro_R <= (~({5'd0, in_pixel[11 : 8]})) + 1;
           pro_G <= (~({5'd0, in_pixel[7 : 4]})) + 1;
           pro_B <= (~({5'd0, in_pixel[3 : 0]})) + 1;
       end
   9'b111111110: begin
           pro_R <= (~({4'd0, in_pixel[11 : 8], 1'b0})) + 1;
           pro_G <= (~({4'd0, in_pixel[7 : 4], 1'b0})) + 1;
           pro_B <= (~({4'd0, in_pixel[3 : 0], 1'b0})) + 1;
       end
   9'b000000000: begin
           pro_R <= 0;
           pro_G <= 0;
           pro_B <= 0;
      end
   9'b000000001: begin
           pro_R <= ({5'd0, in_pixel[11 : 8]});
           pro_G <= ({5'd0, in_pixel[7 : 4]});
           pro_B <= ({5'd0, in_pixel[3 : 0]});
      end
   9'b000000010: begin
           pro_R <= ({4'd0, in_pixel[11 : 8], 1'd0});
           pro_G <= ({4'd0, in_pixel[7 : 4], 1'd0});
           pro_B <= ({4'd0, in_pixel[3 : 0], 1'd0});
      end
   9'b000000100: begin
           pro_R <= ({3'd0, in_pixel[11 : 8], 2'd0});
           pro_G <= ({3'd0, in_pixel[7 : 4], 2'd0});
           pro_B <= ({3'd0, in_pixel[3 : 0], 2'd0});
      end
   9'b000001000: begin
           pro_R <= ({2'd0, in_pixel[11 : 8], 3'd0});
           pro_G <= ({2'd0, in_pixel[7 : 4], 3'd0});
           pro_B <= ({2'd0, in_pixel[3 : 0], 3'd0});
      end 
   default: begin
                  pro_R <= 0;
                  pro_G <= 0;
                  pro_B <= 0;
         end 
 endcase 
    end
    end
end

always_comb begin
        if(count == 2) begin
            sum_R = pro_R;
            sum_G = pro_G;
            sum_B = pro_B;
            out_wr_temp = 1'b0;
        end else if (count > 2) begin
            sum_R = sum_R + pro_R;
            sum_G = sum_G + pro_G;
            sum_B = sum_B + pro_B;
            out_wr_temp = 1'b0; 
        end else if (count1 > 0 && count == 1) begin
            sum_R = sum_R + pro_R;
            sum_G = sum_G + pro_G;
            sum_B = sum_B + pro_B;                   
            out_pix = (sum_G > 0 && sum_R > 0 && sum_B > 0) ? 1'b1 : 1'b0;
            out_wr_temp = 1'b1;
        end
end
endmodule
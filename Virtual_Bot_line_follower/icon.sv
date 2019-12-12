////////////////////////////////////////////////////////////////////////////////// 
// Engineer: Mugilvanan Vinayagam
// 
// Create Date: 02/06/2019
// Module Name: icon
// Description: To stream icon of rojobot.
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
module icon(
    input logic clk,
    input logic reset,
	input logic [11 : 0] pix_row,		//pixel row from dtg 
	input logic [11 : 0] pix_col,		//pixel column from dtg		
	input logic [7 : 0]  loc_X,			//location in x_axis of bot from rojobot IP 	
	input logic [7 : 0]  loc_Y,			//location in y_axis of bot from rojobot IP 
	input logic [7 : 0]  bot_info,		//orientation of bot from rojobot IP
	output logic [1 : 0]  icon_out		//icon color stream
	);

logic [9 : 0] count_0;
logic [9 : 0] count_1;
logic [9 : 0] count_2;
logic [9 : 0] count_3;
logic [11 : 0] locx_temp;
logic [11 : 0] locy_temp;
logic clear;
logic enable;
logic [1 : 0]tilted;
logic [1 : 0]straight;
logic [9 : 0]addr;
typedef enum {IDLE, ICON} states_t;		//states for FSM
typedef enum logic [2:0]{A_0, A_45, A_90, A_135, A_180, A_225, A_270, A_315}angles_t; //orientations of bot

angles_t angle;
states_t state, n_st;

assign locy_temp = {3'b000, loc_Y, 1'b0} * 12'd3; //upscaling loc_Y
assign locx_temp = {1'b0, loc_X, 3'b000};		  //upscaling loc_X

always_ff @(posedge clk) begin : proc_state
	if(reset) begin
		state <= IDLE;
	end else begin
		state <= n_st;
	end
end

counter_0 c1 (.*, .count(count_0));				//used for orientations 0 and 45
counter_1 c2 (.*, .count(count_2));				//used for orientations 180 and 225
counter_2 c3 (.*, .count(count_1));				//used for orientations 90 and 135
counter_3 c4 (.*, .count(count_3));				//used for orientations 270 and 315
blk_mem_gen_1 strat (
  .clka(clk),       // input wire clka
  .addra(addr),     // input wire [9 : 0] addra
  .douta(straight)  // output wire [1 : 0] douta
);
blk_mem_gen_2 tilt (
  .clka(clk),      // input wire clka
  .addra(addr),    // input wire [9 : 0] addra
  .douta(tilted)   // output wire [1 : 0] douta
);
always_comb begin
	case(state)
		IDLE:				//Idle state
			begin
				if(locy_temp == pix_row && locx_temp == pix_col) begin
					n_st = ICON;
					clear = 0;
					enable = 1;
					case(bot_info[2:0])
						A_0, A_45   : begin addr = count_0; icon_out = bot_info[0] ? tilted : straight; end //LSB of bot_info is used to select one of two block ROM outputs
						A_90, A_135 : begin addr = count_1; icon_out = bot_info[0] ? tilted : straight; end //address to block ROM is assign based on the orientation
						A_180, A_225: begin addr = count_2; icon_out = bot_info[0] ? tilted : straight; end
						A_270, A_315: begin addr = count_3; icon_out = bot_info[0] ? tilted : straight; end
					endcase
				end else begin
					n_st = IDLE;
					clear = 1;
					enable = 0;
					icon_out = 0;
					addr = 0;
				end 
			end
		ICON:				//Streaming state								
			begin
				if((pix_row - locy_temp) >=0 && (pix_row -locy_temp) < 32 && (pix_col - locx_temp) >=0 && (pix_col - locx_temp) < 32) begin
					enable = 1;
					n_st = ICON;
					case(bot_info[2:0])
					A_0, A_45   : begin addr = count_0; icon_out = bot_info[0] ? tilted : straight; end
                    A_90, A_135 : begin addr = count_1; icon_out = bot_info[0] ? tilted : straight; end
                    A_180, A_225: begin addr = count_2; icon_out = bot_info[0] ? tilted : straight; end
                    A_270, A_315: begin addr = count_3; icon_out = bot_info[0] ? tilted : straight; end
					endcase					
				end else if((pix_row - locy_temp) == 31 && (pix_col - locx_temp) == 32) begin
					enable = 0;
					n_st = IDLE;
					icon_out = 0;
				end else begin
					enable = 0;
					n_st = ICON;
					icon_out = 0;
				end
			end
		default:
			n_st = IDLE;
	endcase
end

endmodule

////////////////////////////////////////////////////////////////////////////////// 
// Engineer: Mugilvanan Vinayagam
// 
// Create Date: 02/06/2019
// Module Name: Colorizer
// Description: Multiplex world map and icon pixel stream.
//////////////////////////////////////////////////////////////////////////////////
module Colorizer(
	input video_on,				//control to stream pixels 
	input [1 : 0]world,			//world map pixels stream
	input [1 : 0]icon,			//icon pixels stream
	output logic [3 : 0]red,    //output to red port in VGA
	output logic [3 : 0]green,	//output to green port in VGA
	output logic [3 : 0]blue	//output to blue port in VGA
	);

	always_comb 
	begin
		if(~video_on)
			{red, green, blue} = 12'h000;					//streams black pixels if video_on if low
		else begin
			if(icon == 0) begin								//world map pixels are streamed if icon color is zero
				case(world)
					2'b00: {red, green, blue} = 12'hfff;	//world map color 00 is decoded to white
					2'b01: {red, green, blue} = 12'h000;	//world map color 01 is decoded to black
					2'b10: {red, green, blue} = 12'hf00;	//world map color 10 is decoded to red
					2'b11: {red, green, blue} = 12'h111;	//world map color 11 is decoded to some random color
					default: {red, green, blue} = 12'h000;
				endcase // world
			end else if (icon == 1) begin
				{red, green, blue} = 12'h00f;				//icon color 01 is decoded to blue
			end else if (icon == 2) begin
				{red, green, blue} = 12'h0f0;				//icon color 10 is decoded to green
			end else begin
				{red, green, blue} = 12'h0ff;				//icon color 11 is decoded to mix of green and blue
			end
		end
	end
endmodule	

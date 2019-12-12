////////////////////////////////////////////////////////////////////////////////// 
// Engineer: Mugilvanan Vinayagam
// 
// Create Date: 02/06/2019
// Module Name: scale
// Description: Downscale pixel value to lower resolution and find address of pixel in world map ROM.
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
module scale(
	input logic [11 : 0] pixel_row,
	input logic [11 : 0] pixel_column,
	output logic [13 : 0] vid_address );

logic [11 : 0] div_8;
logic [11 : 0] div_6;

assign div_8 = {3'b000, pixel_column[11 : 3]};				//pixel_column/8
assign div_6 = {1'b0, pixel_row[11 : 1]}/3;					//pixel_row/6	
assign vid_address = {div_6[6 : 0], div_8[6 : 0]};			//concatenates div_6 and div_8	

endmodule

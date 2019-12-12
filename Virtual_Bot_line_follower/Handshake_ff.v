`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Engineer: Mugilvanan Vinayagam
// 
// Create Date: 02/06/2019 08:35:17 PM
// Module Name: Handshake_ff
// Description: Synchronise IO_BotUpdt signal which is running in 75MHZ to a clock of 50MHZ.
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module Handshake_ff(
    input clk50,
    input IO_INT_ACK,
    input IO_BotUpdt,
    output reg IO_BotUpdt_Sync
    );

always @ (posedge clk50) begin
    if (IO_INT_ACK == 1'b1) begin
        IO_BotUpdt_Sync <= 1'b0;
    end
    else if (IO_BotUpdt == 1'b1) begin
        IO_BotUpdt_Sync <= 1'b1;
    end else begin
        IO_BotUpdt_Sync <= IO_BotUpdt_Sync;
    end
end    
endmodule

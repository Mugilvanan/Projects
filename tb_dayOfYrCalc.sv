`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mugilavanan Vinayagam
// 
// Create Date: 09/30/2018 01:26:30 PM
// Design Name: 
// Module Name: tb_dayOfYrCalc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench is parameterized so that parameter can be assigned in vsim command.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_dayOfYrCalc #(parameter c_s = 1'b0)();         //parameter for calendar select. provided to ease assignment in command line
     
    reg [5:0] dayOfMonth;
    reg [3:0] month;
    reg [10:0] year;
    wire [8:0] dayOfYear;
    
    dayOfYrCalc #(.cal_select(c_s)) DUT(.dayOfMonth(dayOfMonth), .month(month), .year(year), .dayOfYear(dayOfYear));
    
    initial
    begin
        dayOfMonth = 0; month = 0; year = 0;
        #10 dayOfMonth = 24; month = 3; year = 2002;
        #10 dayOfMonth = 31; month = 12; year = 2009;
        #10 dayOfMonth = 30; month = 11; year = 2010;
        #10 dayOfMonth = 1; month = 12; year = 2006;
        #10 dayOfMonth = 29; month = 8; year = 2007;
        #10 dayOfMonth = 23; month = 6; year = 1996;
        #10 dayOfMonth = 5; month = 4; year = 1994;
        #10 dayOfMonth = 13; month = 1; year = 1970;
        #10 dayOfMonth = 16; month = 2; year = 1974;
        #10 dayOfMonth = 29; month = 8; year = 2004;
    end    

    initial 
        $monitor ("time = %d, dayOfMonth = %6d, month = %4d, year = %11d, dayOfYear = %9d", $time, dayOfMonth, month, year, dayOfYear);
        
endmodule

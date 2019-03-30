 `timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Portland State University   
// Engineer: Mugilvanan Vinayagam
// 
// Create Date: 09/30/2018 11:48:13 AM
// Design Name: Calendar
// Module Name: dayOfYrCalc
// Project Name: Calendar
// Description: Takes dayOfMonth, month and year as inputs and gives day of the year as output.  
// The function used to find day of the year is implemented in the package.
// 
// Dependencies: Packages.sv
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
// `include "packages.sv"

module dayOfYrCalc #(
parameter logic cal_select = 1'b0)                // parameter to select type of calendar (Gregorian(1'b0) or Symmetry454(1'b1))
    (
    input logic [5:0] dayOfMonth,
    input logic [3:0] month,
    input logic [10:0] year,
    output logic [8:0] dayOfYear
    );
    
    // import packages::*;
    
    wire leap;
    logic [5:0] daysOfMonth [1:12];
    wire [1:0] days_sel;
    logic [8:0] temp_out;
    integer i;
    
    assign leap = (year[1:0] == 2'b00) & (~cal_select);           //leap year detection for Gregorian
    assign days_sel = {cal_select, leap};
    
    always @(days_sel)
    begin
        casex(days_sel)
            2'b00: daysOfMonth = packages::day_Gregorian;
            2'b01: daysOfMonth = packages::day_Gregorian_l;        //day array selection logic
            2'b1X: daysOfMonth = packages::day_Symmetry;
        endcase 
    end
    
    always @(dayOfMonth or month or year or days_sel)
    begin
        temp_out = packages::Calc(dayOfMonth, month, daysOfMonth);   //function to find day of the year
    end
    
    always @(temp_out)
        dayOfYear = temp_out; 
endmodule

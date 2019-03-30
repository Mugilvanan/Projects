//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mugilvanan Vinayagam
// 
// Create Date: 09/30/2018 12:01:17 PM
// Design Name: Calendar
// Module Name: packages
// Project Name: Calendar
// 
// Description: Package file contains different day arrays and a function to calculate day of the year.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


package packages;

const logic [5:0] day_Gregorian [1:12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
const logic [5:0] day_Symmetry [1:12] = {28, 35, 28, 28, 35, 28, 28, 35, 28, 28, 35, 28};
const logic [5:0] day_Gregorian_l [1:12] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
const logic [5:0] day_Symmetry_l [1:12] = {28, 35, 28, 28, 35, 28, 28, 35, 28, 28, 35, 35};

function logic [8:0] Calc (input [5:0]dayOfMonth, input [3:0]month, input [5:0] daysOfMonth [1:12]);
   logic [8:0] temp_out;
   int i;
   for (i=1; i<month; i=i+1)
	begin
	  	if(i == 1) 
	  		temp_out = daysOfMonth[i];
	  	else
       		temp_out = temp_out + daysOfMonth[i];
    end
   temp_out = temp_out + dayOfMonth;
   return temp_out;    
endfunction
endpackage

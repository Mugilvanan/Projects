#!/bin/bash
set search_path "/u/mvinay2/Documents/ece527"
#set the target library to build the circuit
set target_library gscl45nm.db
#links the main library for DC to obtain default values and settings
set link_library gscl45nm.db
#reading the verilog RTL netlist
analyze -format sverilog multiplier.sv 
analyze -format sverilog async_fifo.sv
analyze -format sverilog accudiv.sv 
analyze -format sverilog top.sv
elaborate MAC
#link the design and library
link
#setting timing constraints
create_clock -period 83333 -name wclk [get_ports wclk]
create_clock -period 66666 -name rclk [get_ports rclk]
#compile the design to obtain gate level netlist
compile -ungroup_all
#diaplay the timing report
report_timing
#reporting all the references(cell) in the design
report_reference
#create synthesis file
write -f verilog -h -o MAC.v
redirect cell.rpt {report_cell}
redirect qor.rpt {report_qor}
redirect timing.rpt {report_timing}

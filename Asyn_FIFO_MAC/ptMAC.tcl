#!/bin/bash

#set path to search for design files and design libraries 
#(In this case both are same otherwise use'/' to go to next line)
set search_path "/u/mvinay2/Documents/ece527" 

#setting target library .db
 set target_library  gscl45nm.db

#linking library
 set link_library  gscl45nm.db
#reading the verilog RTL netlist
read_verilog  MAC.v


#selecting the current design
current_design MAC
list_libs 

#link the design and library
link_design MAC


#setting timing constraints
create_clock -name wclk -period 83333 [get_ports wclk]
create_clock -name rclk -period 66666 [get_ports rclk]

set_input_delay 20 -clock [get_clocks wclk] [get_ports D*]
set_input_delay 5 -clock [get_clocks rclk] [get_pins -hierarchical -regexp "^ACCUDIV.*data.*D"]

report_constraint -all_violators
redirect violations.rpt {report_constraint -all_violators}

report_timing -delay_type max
redirect setup.rpt {report_timing -delay_type max}

report_timing -delay_type min
redirect hold.rpt {report_timing -delay_type min}


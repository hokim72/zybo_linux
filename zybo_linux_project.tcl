# Usage:
# vivado -source zybo_linux_project.tcl

set path_rtl rtl
set path_ip ip
set path_xdc xdc
set part xc7z010clg400-1

# create a project

create_project -part $part -force zybo_linux ./project

# create PS DB (processing system block design)
source  $path_ip/system_bd.tcl

# generate files
generate_target all [get_files system.bd]

# read files:
# 1. RTL design sources
# 2. IP database files
# 3. constraints
read_verilog    ./project/zybo_linux.srcs/sources_1/bd/system/hdl/system_wrapper.v

add_files       $path_rtl/axi_slave.v
add_files       $path_rtl/axi_master.v
add_files       $path_rtl/system_ps.v
#add_files       $path_rtl/axi_wr_fifo.v
add_files       $path_rtl/system_pl.v
add_files       $path_rtl/zybo_linux_top.v

add_files -fileset constrs_1    $path_xdc/zybo_linux.xdc


import_files -force

update_compile_order -fileset sources_1

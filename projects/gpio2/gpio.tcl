# vivado -nolog -nojournal -mode batch -source gpio.tcl
set project_name gpio
set part_name xc7z010clg400-1
set bd_path $project_name/$project_name.srcs/sources_1/bd/system

file delete -force $project_name

create_project -part $part_name $project_name $project_name

create_bd_design system

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_0
create_bd_port -dir O -from 3 -to 0 leds_o
create_bd_port -dir I -from 3 -to 0 btns_i
create_bd_port -dir I -from 3 -to 0 sws_i

create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 ps_0
source zybo_preset.tcl
set_property -dict [apply_preset IPINST] [get_bd_cells ps_0]
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {
	    make_external {FIXED_IO, DDR}
} [get_bd_cells ps_0]

create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 slice_0
set_property -dict [list CONFIG.DIN_WIDTH {64} CONFIG.DIN_FROM {3} CONFIG.DIN_TO {0} CONFIG.DOUT_WIDTH {4}] [get_bd_cells slice_0]

create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 concat_0
set_property -dict [list CONFIG.NUM_PORTS {3} CONFIG.IN0_WIDTH {4} CONFIG.IN1_WIDTH {4} CONFIG.IN2_WIDTH {4}] [get_bd_cells concat_0]

connect_bd_intf_net [get_bd_intf_pins ps_0/IIC_0] [get_bd_intf_ports IIC_0]
connect_bd_net [get_bd_pins ps_0/GPIO_O] [get_bd_pins slice_0/Din]
connect_bd_net [get_bd_ports leds_o] [get_bd_pins slice_0/Dout]
connect_bd_net [get_bd_pins concat_0/dout] [get_bd_pins ps_0/GPIO_I]
connect_bd_net [get_bd_ports btns_i] [get_bd_pins concat_0/In1]
connect_bd_net [get_bd_ports sws_i] [get_bd_pins concat_0/In2]

generate_target all [get_files $bd_path/system.bd]
make_wrapper -files [get_files $bd_path/system.bd] -top

add_files -norecurse $bd_path/hdl/system_wrapper.v

add_files -norecurse -fileset constrs_1 zybo_gpio.xdc

set_property verilog_define {TOOL_VIVADO} [current_fileset]
#set_property strategy Flow_PerfOptimized_High [get_runs synth_1]
#set_property strategy Performance_NetDelay_high [get_runs impl_1]

close_project


##Clock signal
##IO_L11P_T1_SRCC_35
set_property PACKAGE_PIN L16 [get_ports clk_i]
set_property IOSTANDARD LVCMOS33 [get_ports clk_i]
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports clk_i]

##LEDs
set_property IOSTANDARD LVCMOS33 [get_ports {led_o[*]}]
##IO_L23P_T3_35
set_property PACKAGE_PIN M14 [get_ports {led_o[0]}]

##IO_L23N_T3_35
set_property PACKAGE_PIN M15 [get_ports {led_o[1]}]

##IO_0_35
set_property PACKAGE_PIN G14 [get_ports {led_o[2]}]

##IO_L3N_T0_DQS_AD1N_35
set_property PACKAGE_PIN D18 [get_ports {led_o[3]}]

##Audio Codec/external EEPROM IIC bus
##IO_L13P_T2_MRCC_34
set_property PACKAGE_PIN N18 [get_ports iic_0_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_0_scl_io]

##IO_L23P_T3_34
set_property PACKAGE_PIN N17 [get_ports iic_0_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_0_sda_io]

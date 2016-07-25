##Audio Codec/external EEPROM IIC bus
##IO_L13P_T2_MRCC_34
set_property PACKAGE_PIN N18 [get_ports iic_0_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_0_scl_io]

##IO_L23P_T3_34
set_property PACKAGE_PIN N17 [get_ports iic_0_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_0_sda_io]

# Leds
set_property IOSTANDARD LVCMOS33 [get_ports leds_o[*]]

set_property PACKAGE_PIN M14 [get_ports leds_o[0]]
set_property PACKAGE_PIN M15 [get_ports leds_o[1]]
set_property PACKAGE_PIN G14 [get_ports leds_o[2]]
set_property PACKAGE_PIN D18 [get_ports leds_o[3]]

# Buttons
set_property IOSTANDARD LVCMOS33 [get_ports btns_i[*]]

set_property PACKAGE_PIN R18 [get_ports btns_i[0]]
set_property PACKAGE_PIN P16 [get_ports btns_i[1]]
set_property PACKAGE_PIN V16 [get_ports btns_i[2]]
set_property PACKAGE_PIN Y16 [get_ports btns_i[3]]

# Switches
set_property IOSTANDARD LVCMOS33 [get_ports sws_i[*]]

set_property PACKAGE_PIN G15 [get_ports sws_i[0]]
set_property PACKAGE_PIN P15 [get_ports sws_i[1]]
set_property PACKAGE_PIN W13 [get_ports sws_i[2]]
set_property PACKAGE_PIN T16 [get_ports sws_i[3]]

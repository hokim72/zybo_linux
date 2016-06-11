##Audio Codec/external EEPROM IIC bus
##IO_L13P_T2_MRCC_34
set_property PACKAGE_PIN N18 [get_ports iic_0_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_0_scl_io]

##IO_L23P_T3_34
set_property PACKAGE_PIN N17 [get_ports iic_0_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_0_sda_io]

set_property IOSTANDARD LVCMOS33 [get_ports spi_*]

# Pmod JE
# SPI CS 0
#set_property PACKAGE_PIN V12 [get_ports spi_ss_io[0]]
# SPI CS 1
#set_property PACKAGE_PIN W16 [get_ports spi_ss_io[1]]
# SPI SCLK
#set_property PACKAGE_PIN J15 [get_ports spi_sck_io]
# SPI MOSI
#set_property PACKAGE_PIN H15 [get_ports spi_io0_io]
# SPI MISO
#set_property PACKAGE_PIN V13 [get_ports spi_io1_io]

# Pmod JD
# SPI CS 0
set_property PACKAGE_PIN T14 [get_ports spi_ss_io[0]]
# SPI CS 1
set_property PACKAGE_PIN T15 [get_ports spi_ss_io[1]]
# SPI SCLK
set_property PACKAGE_PIN P14 [get_ports spi_sck_io]
# SPI MOSI
set_property PACKAGE_PIN R14 [get_ports spi_io0_io]
# SPI MISO
set_property PACKAGE_PIN U14 [get_ports spi_io1_io]

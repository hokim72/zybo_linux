# build artefacts
FPGA_BIT=out/zybo_linux.bit
BOOT_BIN=target/boot.bin
LINUX_IMG=target/uImage
DEVICE_TREE=target/devicetree.dtb

TMP = tmp
# check if download cache directory is available
ifdef BR2_DL_DIR
DL=$(BR2_DL_DIR)
else
DL=$(TMP)
endif

# Vivado from Xilinx provides IP handling, FPGA compilation
# hsi (hardware software interface) provides software integration
# both tools are run in batch mode with an option to avoid log/journal files
VIVADO = vivado -nolog -nojournal -mode batch
HSI    = hsi    -nolog -nojournal -mode batch

.PHONY: all clean project boot_bin image

all: $(FPGA_BIT) 

boot_bin: $(BOOT_BIN)
	
target: boot_bin $(LINUX_IMG) $(DEVICE_TREE)

clean:
#rm -rf out .Xil .srcs sdk
	rm -fr target sdk out tmp dl usage_statistics_webtalk.* .srcs .Xil 

project:
	vivado -source zybo_linux_project.tcl

$(FPGA_BIT):
	$(VIVADO) -source zybo_linux.tcl

$(BOOT_BIN): $(FPGA_BIT)
	$(HSI) -source zybo_linux_hsi_fsbl.tcl
	make -f Makefile.boot

$(LINUX_IMG):
	make -f Makefile.linux

$(DEVICE_TREE): $(FPGA_BIT)
	make -f Makefile.dtree 

image: target
	sudo ./image.sh

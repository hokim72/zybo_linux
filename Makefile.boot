TMP = tmp
# check if download cache directory is available
ifdef BR2_DL_DIR
DL=$(BR2_DL_DIR)
else
DL=$(TMP)
endif
TARGET=target

UBOOT_TAG     = xilinx-v2015.4
UBOOT_DIR     = $(TMP)/u-boot-xlnx-$(UBOOT_TAG)
UBOOT_TAR     = $(DL)/u-boot-xlnx-$(UBOOT_TAG).tar.gz
UBOOT_URL     ?= https://github.com/Xilinx/u-boot-xlnx/archive/$(UBOOT_TAG).tar.gz
UBOOT_GIT     ?= https://github.com/Xilinx/u-boot-xlnx.git

ifeq ($(CROSS_COMPILE),arm-xilinx-linux-gnueabi-)
UBOOT_CFLAGS = "-O2 -mtune=cortex-a9 -mfpu=neon -mfloat-abi=soft"
else
UBOOT_CFLAGS = "-O2 -mtune=cortex-a9 -mfpu=neon -mfloat-abi=hard"
endif

FSBL            = $(PWD)/sdk/fsbl/executable.elf
FPGA			= $(PWD)/out/zybo_linux.bit
UBOOT           = $(TMP)/u-boot.elf
BOOT_UBOOT      = $(TMP)/boot.bin

ENVTOOLS_CFG    = $(TMP)/etc/fw_env.config
UBOOT_SCRIPT_UBUNTU    = patches/u-boot.script.ubuntu
UBOOT_SCRIPT           = $(TMP)/u-boot.scr

$(TARGET): $(BOOT_UBOOT) u-boot
	mkdir -p $(TARGET)
	cp $(BOOT_UBOOT) $(TARGET)/boot.bin
	cp $(UBOOT_SCRIPT) $(TARGET)

$(DL):
	mkdir -p $@

$(TMP):
	mkdir -p $@

$(BOOT_UBOOT): $(UBOOT)
	@echo img:{[bootloader] $(FSBL) $(FPGA) $(UBOOT) } > $(TMP)/boot_uboot.bif
	bootgen -image $(TMP)/boot_uboot.bif -w -o $@

.PHONY: u-boot

u-boot: $(UBOOT) $(UBOOT_SCRIPT) $(ENVTOOLS_CFG)

$(UBOOT_TAR): | $(DL)
	curl -L $(UBOOT_URL) -o $@

$(UBOOT_DIR): $(UBOOT_TAR)
	mkdir -p $@
	tar -zxf $< --strip-components=1 --directory=$@
	patch -d $@ -p 1 < patches/u-boot-xlnx-$(UBOOT_TAG).patch

$(UBOOT): $(UBOOT_DIR)
	mkdir -p $(@D)
	make -C $< arch=ARM zynq_zybo_defconfig
	make -C $< arch=ARM CFLAGS=$(UBOOT_CFLAGS) all
	cp $</u-boot $@

$(UBOOT_SCRIPT): $(UBOOT_DIR) $(UBOOT_SCRIPT_UBUNTU)
	$(UBOOT_DIR)/tools/mkimage -A ARM -O linux -T script -C none -a 0 -e 0 -n "boot Ubuntu"    -d $(UBOOT_SCRIPT_UBUNTU)    $@.ubuntu
	cp $@.ubuntu $@

$(ENVTOOLS_CFG): $(UBOOT_DIR)
	mkdir -p $(TMP)/etc/
	cp $</tools/env/fw_env.config $(TMP)/etc

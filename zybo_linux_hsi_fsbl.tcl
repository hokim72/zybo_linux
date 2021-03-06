################################################################################
# HSI tcl script for building Zybo FSBL
#
# Usage:
# hsi -mode tcl -source zybo_linux_hsi_fsbl.tcl
################################################################################

set path_sdk sdk

open_hw_design $path_sdk/zybo_linux.sysdef
generate_app -hw system_0 -os standalone -proc ps7_cortexa9_0 -app zynq_fsbl -compile -sw fsbl -dir $path_sdk/fsbl

exit

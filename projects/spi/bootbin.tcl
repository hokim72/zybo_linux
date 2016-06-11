# tclsh bootbin.tcl
set project_name spi

set fileId [open $project_name/boot.bif "w"]
puts $fileId "img:{\[bootloader\] $project_name/$project_name.fsbl/executable.elf $project_name/$project_name.runs/impl_1/system_wrapper.bit $::env(HOME)/work/zybo_linux/u-boot.elf}"
close $fileId
exec bootgen -image $project_name/boot.bif -w -o i boot.bin >&@stdout

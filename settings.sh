
################################################################################
# setup Linaro toolchain
################################################################################

export TOOLCHAIN_PATH=/opt/linaro/gcc-linaro-4.9-2014.11-x86_64_arm-linux-gnueabihf/
export PATH=$PATH:$TOOLCHAIN_PATH/bin
export CROSS_COMPILE=arm-linux-gnueabihf-

#export BR2_DL_DIR=$HOME/Workplace/buildroot/dl
export BR2_DL_DIR=dl


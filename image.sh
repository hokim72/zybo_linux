mkdir -p dl

UBUNTU_URL=http://cdimage.ubuntu.com/ubuntu-core/releases/16.04/release
UBUNTU=ubuntu-core-16.04-core-armhf.tar.gz
if [ ! -f dl/$UBUNTU ]; then
curl -L $UBUNTU_URL/$UBUNTU -o dl/$UBUNTU
fi
#DATE=`date +"%H-%M-%S_%d-%b-%Y"`
ARCH=armhf
SIZE=3500
mkdir -p img
#IMAGE=img/ubuntu_${ARCH}_${DATE}.img
IMAGE=img/ubuntu_${ARCH}_16.04_zybo.img
dd if=/dev/zero of=$IMAGE bs=1M count=$SIZE
DEVICE=`losetup -f`
losetup $DEVICE $IMAGE
parted -s $DEVICE mklabel msdos
parted -s $DEVICE mkpart primary fat16 4MB 128MB
parted -s $DEVICE mkpart primary ext4 128MB 100%
BOOT_DEV=/dev/`lsblk -lno NAME $DEVICE | sed '2!d'`
ROOT_DEV=/dev/`lsblk -lno NAME $DEVICE | sed '3!d'`
mkfs.vfat -v $BOOT_DEV
mkfs.ext4 -F -j $ROOT_DEV
BOOT_DIR=boot
ROOT_DIR=root
mkdir -p $BOOT_DIR $ROOT_DIR
mount $BOOT_DEV $BOOT_DIR
mount $ROOT_DEV $ROOT_DIR
cd $ROOT_DIR
tar xvf ../dl/$UBUNTU
rm -fr $BOOT
cd ..
cp target/* -d $BOOT_DIR
cat > $ROOT_DIR/etc/fstab << EOF_CAT
# /etc/fstab: static file system information.
# <file system> <mount point>   <type>  <options>              <dump>  <pass>
/dev/mmcblk0p2  /               ext4    errors=remount-ro      0       1
/dev/mmcblk0p1  /boot           vfat    ro,defaults            0       0
EOF_CAT

cp /etc/resolv.conf         $ROOT_DIR/etc/
cp /usr/bin/qemu-arm-static $ROOT_DIR/usr/bin/
chroot $ROOT_DIR << EOF_CHROOT
apt-get update
apt-get -y upgrade
apt-get -y install vim sudo openssh-server udev usbutils u-boot-tools net-tools wpasupplicant parted rfkill lshw wireless-tools gcc g++ cmake git
echo "Asia/Seoul" > /etc/timezone
#dpkg-reconfigure --frontend=noninteractive tzdata
ln -fs /usr/share/zoneinfo/Asia/Seoul /etc/localtime
groupadd -g 1000 hokim
groupadd -g 1001 admin
useradd -u 1000 -g 1000 -G adm,dialout,cdrom,audio,dip,video,plugdev,admin -d /home/hokim -m -s /bin/bash hokim
echo 'hokim:1234' | chpasswd
EOF_CHROOT
rm $ROOT_DIR/etc/resolv.conf
rm $ROOT_DIR/usr/bin/qemu-arm-static

cat > $ROOT_DIR/etc/hostname << EOF_CAT
zybo
EOF_CAT

#sed -i 's/^127\.0\.1\.1.*/127\.0\.1\.1\tsan_engr/' $ROOT_DIR/etc/hosts
cat > $ROOT_DIR/etc/hosts << EOF_CAT
127.0.0.1       localhost
127.0.1.1       zybo

# The following lines are desirable for IPv6 capable hosts
::1             ip6-localhost ip6-loopback
fe00::0         ip6-localnet
ff00::0         ip6-mcastprefix
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters
EOF_CAT

cat > $ROOT_DIR/etc/network/interfaces.d/eth0 << EOF_CAT
allow-hotplug eth0
iface eth0 inet static
address 192.168.10.10
netmask 255.255.255.0
EOF_CAT

mkdir -pv $ROOT_DIR/etc/systemd/system/serial-getty\@ttyPS0.service.d
cat > $ROOT_DIR/etc/systemd/system/serial-getty\@ttyPS0.service.d/autologin.conf << EOF_CAT
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin root -s %I 115200,38400,9600 linux
EOF_CAT

umount -l $BOOT_DIR 
umount -l $ROOT_DIR
rmdir $BOOT_DIR $ROOT_DIR
losetup -d $DEVICE

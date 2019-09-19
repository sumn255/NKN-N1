#!/bin/bash

[ "$EUID" != "0" ] && echo "please run as root" && exit 1

DIR=$(pwd)
BOOTDIR="/media/xubuntu/BOOT/"
ROOTFSDIR="/media/xubuntu/ROOTFS/"

cd $BOOTDIR || exit 1
cp -f ${DIR}/target/meson-gxl-s905d-phicomm-n1.dtb ./dtb/
sed -i '/^dtb_name=/cdtb_name=/dtb/meson-gxl-s905d-phicomm-n1.dtb' ./uEnv.ini
sync

cd $ROOTFSDIR || exit 1
#cp -f ${DIR}/target/preinstall.sh ./root
cp -f ${DIR}/target/install.sh ./root
cp -f ${DIR}/target/firstboot.sh ./root
cp -f ${DIR}/target/start_worker.sh ./root
cp -f ${DIR}/target/rc.local ./etc/rc.local
cp -f ${DIR}/target/init-worker.sh ./usr/local/bin
cp -f ${DIR}/target/init-worker.service ./lib/systemd/system
cp -f ${DIR}/target/usb-mount.sh ./usr/local/bin
cp -f ${DIR}/target/usb-mount@.service ./etc/systemd/system
cp -f ${DIR}/target/99-local.rules ./etc/udev/rules.d/99-local.rules.1
mkdir -p ./etc/docker
cp -f ${DIR}/target/daemon.json ./etc/docker/daemon.json 

rm -f ./root/install-2018.sh
rm -f ./etc/systemd/system/getty.target.wants/serial-getty@ttyS0.service
ln -sf /usr/share/zoneinfo/Asia/Shanghai ./etc/localtime
sed -i '/^#NTP=/cNTP=time1.aliyun.com 2001:470:0:50::2' ./etc/systemd/timesyncd.conf
echo "Asia/Shanghai" > ./etc/timezone
cat > ./root/.bash_aliases << EOF
alias df='df -Th'
alias free='free -h'
alias ls='ls -hF --color=auto'
alias ll='ls -AlhF --color=auto'
EOF
#sed -i 's/httpredir.debian.org/mirrors.tuna.tsinghua.edu.cn/' ./etc/apt/sources.list
sed -i 's/ports.ubuntu.com/mirrors.tuna.tsinghua.edu.cn\/ubuntu-ports/' ./etc/apt/sources.list
sed -i 's/http/https/' ./etc/apt/sources.list
#sed -i '/security/d' ./etc/apt/sources.list
#echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian-security stretch/updates main contrib non-free" >> ./etc/apt/sources.list
sync

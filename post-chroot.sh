#!/bin/sh

[ "$EUID" != "0" ] && echo "please run as root" && exit 1

#udevadm control --reload-rules
#apt update 
#curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/debian/gpg |apt-key add -
#add-apt-repository "deb [arch=arm64] https://mirrors.aliyun.com/docker-ce/linux/debian $(lsb_release -cs) stable"
curl -fsSL https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu/gpg |apt-key add -
add-apt-repository "deb [arch=arm64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
#apt update
apt upgrade -y
apt clean
apt install -y jq docker-ce 
apt clean
systemctl disable docker.service
systemctl disable containerd.service
#systemctl disable armbian-resize-filesystem.service
#sed -i '/After/a\RequiresMountsFor=\/media\/sda1' /lib/systemd/system/docker.service
#sed -i '/After/a\Requires=media-sda1.mount' /lib/systemd/system/containerd.service
#sed -i 's/docker.socket/docker.socket media-sda1.mount/' /lib/systemd/system/docker.service
strip /usr/bin/docker
strip /usr/bin/dockerd
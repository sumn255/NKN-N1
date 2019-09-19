#!/bin/sh

apt-get update && \
apt-get -y purge ifupdown haveged && \
apt-get -y install rng-tools && \
apt-get -y autoremove && \
apt-get clean

echo "root:admin" | chpasswd

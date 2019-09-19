#!/usr/bin/env bash

MOUNT_STAT=$(systemctl status mnt-sda1.mount|grep mounted|awk '{ print $3 }')

if [[ -n ${MOUNT_STAT} ]]; then
    [ -f /root/dockerdir.tar ] && mkdir -p /mnt/sda1/docker/volumes/nkn-mining_bin/_data && tar -xpf /root/dockerdir.tar -C /mnt/sda1/docker --remove-files && cp /root/config.json /mnt/sda1/docker/volumes/nkn-mining_bin/_data && sed -i '/dockerdir/d' /root/start_worker.sh
    systemctl start docker.service
    sleep 3
    SWARM_STAT=$(docker info|grep Swarm|awk '{ print $2 }')
    if [[ ${SWARM_STAT} == "inactive" ]]; then
        systemctl start init-worker.service
    fi
    if [[ ${SWARM_STAT} == "error" ]]; then
        systemctl restart docker.service
    fi
fi

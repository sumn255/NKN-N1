#!/bin/bash

cluster=$(curl -s https://docker-swarm.nkn.org/join | jq '.cluster')
docker swarm join --token $(echo $cluster | jq -r '.token') \
  $(echo $cluster | jq -r '.endPoint') \
  && systemctl disable init-worker

#!/bin/bash

kickstart.context "Monitoring"

mkdir -p /etc/netdata
cp files/netdata/* /etc/netdata/

docker pull netdata/netdata
docker rm -f netdata
docker run -d --name=netdata \
    --net=host \
    -v /proc:/host/proc:ro \
    -v /sys:/host/sys:ro \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -v /etc/hostname:/etc/hostname:ro \
    -v /etc/localtime:/etc/localtime:ro \
    -v /etc/netdata/netdata.conf:/etc/netdata/netdata.conf:ro \
    -v /etc/netdata/charts.d.conf:/etc/netdata/charts.d.conf:ro \
    -e PGID="$(grep docker /etc/group | cut -d ':' -f 3)" \
    --cap-add SYS_PTRACE \
    --security-opt apparmor=unconfined \
    --restart=unless-stopped netdata/netdata
docker image prune -fa

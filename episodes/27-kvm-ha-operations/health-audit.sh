#!/usr/bin/env bash
set -Eeuo pipefail

sudo pcs status --full
sudo corosync-quorumtool -s
sudo pcs stonith config
sudo pcs stonith history
sudo gluster peer status
sudo gluster volume status ha-volume
sudo gluster volume heal ha-volume info summary
sudo pcs resource failcount show ha-demo01

#!/usr/bin/env bash
set -Eeuo pipefail

volume="${1:-ha-volume}"

sudo gluster peer probe kvm-ha02
sudo gluster peer probe kvm-ha03
sudo gluster volume create "$volume" replica 3 \
  kvm-ha01:/srv/gluster/ha-volume/brick \
  kvm-ha02:/srv/gluster/ha-volume/brick \
  kvm-ha03:/srv/gluster/ha-volume/brick force
sudo gluster volume start "$volume"
sudo gluster volume set "$volume" network.ping-timeout 10
sudo gluster volume info "$volume"
sudo gluster volume status "$volume"

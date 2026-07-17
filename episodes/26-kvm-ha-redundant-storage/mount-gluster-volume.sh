#!/usr/bin/env bash
set -Eeuo pipefail

mountpoint="${1:-/var/lib/libvirt/ha-redundant}"
source="${2:-kvm-ha01:/ha-volume}"
sudo install -d -m 0755 "$mountpoint"
grep -qF "$source $mountpoint" /etc/fstab || \
  printf '%s %s glusterfs defaults,_netdev,backupvolfile-server=kvm-ha02 0 0\n' \
    "$source" "$mountpoint" | sudo tee -a /etc/fstab >/dev/null
mountpoint -q "$mountpoint" || sudo mount "$mountpoint"
findmnt "$mountpoint"

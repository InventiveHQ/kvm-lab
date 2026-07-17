#!/usr/bin/env bash
set -Eeuo pipefail

mountpoint="${1:-/var/lib/libvirt/ha-shared}"
source="${2:-192.168.124.1:/models/vms/labs/ihq-kvm-ha-shared}"
sudo install -d -m 0755 "$mountpoint"
grep -qF "$source $mountpoint" /etc/fstab || \
  printf '%s %s nfs4 rw,_netdev,hard,timeo=600 0 0\n' "$source" "$mountpoint" | sudo tee -a /etc/fstab >/dev/null
mountpoint -q "$mountpoint" || sudo mount "$mountpoint"
findmnt "$mountpoint"

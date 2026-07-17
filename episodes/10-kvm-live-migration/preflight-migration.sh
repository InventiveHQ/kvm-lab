#!/usr/bin/env bash
set -euo pipefail

domain=${DOMAIN:-demo-ubuntu01}
destination=${DESTINATION_URI:-qemu+ssh://sean@192.168.124.12/system}

echo '== Source domain =='
sudo virsh dominfo "$domain"
sudo virsh domblklist "$domain" --details
sudo virsh domiflist "$domain"

echo '== Source and destination versions =='
sudo virsh version
virsh -c "$destination" version

echo '== Destination networks and pools =='
virsh -c "$destination" net-list --all
virsh -c "$destination" pool-list --all

if virsh -c "$destination" dominfo "$domain" >/dev/null 2>&1; then
  echo "NO-GO: destination already defines $domain" >&2
  exit 5
fi

for network in default tutorial-net; do
  virsh -c "$destination" net-info "$network" | grep -q 'Active:.*yes' || {
    echo "NO-GO: destination network is not active: $network" >&2
    exit 6
  }
done

echo 'Preflight passed. Review CPU compatibility and free capacity before migration.'

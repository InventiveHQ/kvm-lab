#!/usr/bin/env bash
set -euo pipefail

export LIBVIRT_DEFAULT_URI=${LIBVIRT_DEFAULT_URI:-qemu:///system}
VM=${1:-demo-ubuntu01}
MAC=52:54:00:77:05:01

if [[ ${2:-} != --confirm-guest-config-removed ]]; then
  echo "Remove /etc/netplan/60-tutorial-net.yaml inside $VM and apply Netplan first." >&2
  echo "Then run: $0 $VM --confirm-guest-config-removed" >&2
  exit 2
fi

virsh detach-interface "$VM" network --mac "$MAC" --live --config
virsh net-dhcp-leases tutorial-net
virsh net-destroy tutorial-net
virsh net-undefine tutorial-net

echo "Removed the tutorial NIC and network after explicit confirmation."

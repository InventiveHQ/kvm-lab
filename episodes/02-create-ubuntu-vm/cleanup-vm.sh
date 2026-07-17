#!/usr/bin/env bash
set -euo pipefail

export LIBVIRT_DEFAULT_URI=qemu:///system
VM=demo-ubuntu01
DISK=/var/lib/libvirt/images/${VM}.qcow2
SEED=/var/lib/libvirt/images/${VM}-seed.iso

if [[ ${1:-} != --confirm ]]; then
  echo "This removes $VM, $DISK, and $SEED." >&2
  echo "Re-run as: $0 --confirm" >&2
  exit 2
fi

virsh domblklist "$VM" || true
virsh destroy "$VM" 2>/dev/null || true
virsh undefine "$VM" --nvram 2>/dev/null || virsh undefine "$VM"
sudo rm -f -- "$DISK" "$SEED"

echo "Removed $VM. The shared Ubuntu base image was preserved."

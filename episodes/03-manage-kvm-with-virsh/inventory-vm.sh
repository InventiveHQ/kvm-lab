#!/usr/bin/env bash
set -euo pipefail

VM=${1:-demo-ubuntu01}
URI=${LIBVIRT_DEFAULT_URI:-qemu:///system}

virsh --connect "$URI" --readonly list --all
virsh --connect "$URI" --readonly dominfo "$VM"
virsh --connect "$URI" --readonly domstate "$VM"
virsh --connect "$URI" --readonly domblklist "$VM"
virsh --connect "$URI" --readonly domifaddr "$VM" --source lease
virsh --connect "$URI" dumpxml "$VM" --inactive > "${VM}.xml"

echo "Persistent XML saved to ${VM}.xml"

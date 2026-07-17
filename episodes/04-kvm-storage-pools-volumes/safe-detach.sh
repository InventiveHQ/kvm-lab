#!/usr/bin/env bash
set -euo pipefail

export LIBVIRT_DEFAULT_URI=${LIBVIRT_DEFAULT_URI:-qemu:///system}
VM=${1:-demo-ubuntu01}

if [[ ${2:-} != --confirm-unmounted ]]; then
  echo "First run 'sudo sync' and 'sudo umount /srv/demo-data' inside $VM." >&2
  echo "Then run: $0 $VM --confirm-unmounted" >&2
  exit 2
fi

virsh domblkinfo "$VM" vdb
virsh detach-disk "$VM" vdb --live --config
virsh domblklist "$VM" --details

echo "The storage volume was preserved. Deletion is a separate destructive decision."

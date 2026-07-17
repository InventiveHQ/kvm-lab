#!/usr/bin/env bash
set -euo pipefail

export LIBVIRT_DEFAULT_URI=${LIBVIRT_DEFAULT_URI:-qemu:///system}
VM=${1:-demo-ubuntu01}
POOL=tutorial-data
POOL_PATH=/var/lib/libvirt/tutorial-data
VOLUME=demo-data01.qcow2
VOLUME_PATH=${POOL_PATH}/${VOLUME}

virsh dominfo "$VM" >/dev/null

if virsh pool-info "$POOL" >/dev/null 2>&1; then
  echo "$POOL already exists; inspect it before continuing." >&2
  exit 1
fi
if sudo test -e "$VOLUME_PATH"; then
  echo "$VOLUME_PATH already exists; refusing to overwrite it." >&2
  exit 1
fi
if virsh domblklist "$VM" --details | awk '$3 == "vdb" { found=1 } END { exit !found }'; then
  echo "$VM already has a vdb target; choose another target." >&2
  exit 1
fi

sudo mkdir -p "$POOL_PATH"
virsh pool-define-as "$POOL" dir --target "$POOL_PATH"
virsh pool-build "$POOL"
virsh pool-start "$POOL"
virsh pool-autostart "$POOL"
virsh vol-create-as "$POOL" "$VOLUME" 5GiB --format qcow2
virsh attach-disk "$VM" "$VOLUME_PATH" vdb \
  --targetbus virtio --subdriver qcow2 --live --config

virsh pool-info "$POOL"
virsh vol-info --pool "$POOL" "$VOLUME"
virsh domblklist "$VM" --details

cat <<'EOF'
Inside the guest, identify the new empty device before formatting it:
  lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS
  sudo blkid /dev/vdb || true
  sudo mkfs.ext4 -L demo-data /dev/vdb
  sudo mkdir -p /srv/demo-data
  sudo mount /dev/vdb /srv/demo-data
  echo "InventiveHQ KVM storage lab" | sudo tee /srv/demo-data/README.txt
  df -hT /srv/demo-data
EOF

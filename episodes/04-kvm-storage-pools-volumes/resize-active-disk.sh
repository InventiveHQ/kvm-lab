#!/usr/bin/env bash
set -euo pipefail

export LIBVIRT_DEFAULT_URI=${LIBVIRT_DEFAULT_URI:-qemu:///system}
VM=${1:-demo-ubuntu01}

virsh domblkinfo "$VM" vdb
virsh blockresize "$VM" vdb 8GiB
virsh domblkinfo "$VM" vdb
virsh vol-info --pool tutorial-data demo-data01.qcow2

cat <<'EOF'
Inside the guest, grow the whole-device ext4 filesystem and verify its data:
  lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS /dev/vdb
  sudo resize2fs /dev/vdb
  df -hT /srv/demo-data
  sudo cat /srv/demo-data/README.txt
EOF

#!/usr/bin/env bash
set -euo pipefail

domain=${DOMAIN:-demo-ubuntu01}
backup_dir=${BACKUP_DIR:-/var/lib/libvirt/backups/ep06}

if [[ ${CONFIRM_DISPOSABLE_LAB:-} != "$domain" ]]; then
  echo "Refusing: set CONFIRM_DISPOSABLE_LAB=$domain after reviewing all paths." >&2
  exit 2
fi

sudo virsh domstate "$domain" | grep -qx running
sudo virsh qemu-agent-command "$domain" '{"execute":"guest-ping"}' >/dev/null
sudo install -d -m 0750 "$backup_dir"

sudo virsh snapshot-create-as "$domain" \
  --name ep06-backup --disk-only --quiesce --atomic \
  --diskspec vda,snapshot=external,file=/var/lib/libvirt/images/demo-ubuntu01-ep06-overlay.qcow2,driver=qcow2 \
  --diskspec vdb,snapshot=external,file=/var/lib/libvirt/tutorial-data/demo-data01-ep06-overlay.qcow2,driver=qcow2 \
  --diskspec sda,snapshot=no

sudo virsh dumpxml --inactive "$domain" | sudo tee "$backup_dir/$domain.xml" >/dev/null
sudo qemu-img convert --force-share -p -O qcow2 \
  /var/lib/libvirt/images/demo-ubuntu01.qcow2 \
  "$backup_dir/demo-ubuntu01-system.qcow2"
sudo qemu-img convert --force-share -p -O qcow2 \
  /var/lib/libvirt/tutorial-data/demo-data01.qcow2 \
  "$backup_dir/demo-ubuntu01-data.qcow2"

sudo qemu-img info "$backup_dir/demo-ubuntu01-system.qcow2"
sudo qemu-img info "$backup_dir/demo-ubuntu01-data.qcow2"
echo "Backups created. Boot an isolated restore before committing overlays."

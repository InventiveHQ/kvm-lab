#!/usr/bin/env bash
set -euo pipefail

source_domain=${SOURCE_DOMAIN:-demo-ubuntu01}
clone_domain=${CLONE_DOMAIN:-demo-clone01}

if [[ ${CONFIRM_DISPOSABLE_LAB:-} != "$source_domain" ]]; then
  echo "Refusing: set CONFIRM_DISPOSABLE_LAB=$source_domain after review." >&2
  exit 2
fi

sudo virsh domstate "$source_domain" | grep -qx 'shut off'
if sudo virsh dominfo "$clone_domain" >/dev/null 2>&1; then
  echo "Refusing: destination domain already exists: $clone_domain" >&2
  exit 3
fi

args=(
  --original "$source_domain"
  --name "$clone_domain"
  --file /var/lib/libvirt/images/demo-clone01.qcow2
  --file /var/lib/libvirt/tutorial-data/demo-clone-data01.qcow2
  --check disk_size=off
)

sudo virt-clone "${args[@]}" --print-xml
echo "Review the XML above. Re-run with EXECUTE_CLONE=yes to copy data."
[[ ${EXECUTE_CLONE:-} == yes ]] || exit 0

sudo virt-clone "${args[@]}"
sudo virsh detach-disk "$clone_domain" sda --config
sudo virt-sysprep -d "$clone_domain" \
  --enable machine-id,ssh-hostkeys,dhcp-client-state,net-hostname,udev-persistent-net,customize \
  --hostname "$clone_domain" \
  --run-command 'cloud-init clean --logs'
sudo virsh domuuid "$clone_domain"
sudo virsh domiflist "$clone_domain"
echo "Clone is shut off. Update any MAC-pinned guest network config before boot."

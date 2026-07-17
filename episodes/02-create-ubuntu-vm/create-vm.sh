#!/usr/bin/env bash
set -euo pipefail

export LIBVIRT_DEFAULT_URI=qemu:///system

VM=demo-ubuntu01
BASE=/var/lib/libvirt/images/ubuntu-24.04-server-cloudimg-amd64.img
DISK=/var/lib/libvirt/images/${VM}.qcow2
SEED=/var/lib/libvirt/images/${VM}-seed.iso
IMAGE_URL=https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
PUBLIC_KEY_FILE=${1:-}

if [[ -z $PUBLIC_KEY_FILE || ! -f $PUBLIC_KEY_FILE ]]; then
  echo "Usage: $0 /path/to/public-key.pub" >&2
  exit 2
fi

if [[ $PUBLIC_KEY_FILE != *.pub ]]; then
  echo "Refusing a key path without the .pub suffix." >&2
  exit 2
fi

if virsh dominfo "$VM" >/dev/null 2>&1; then
  echo "$VM already exists; inspect or choose another name first." >&2
  exit 1
fi

for path in "$DISK" "$SEED"; do
  if sudo test -e "$path"; then
    echo "$path already exists; refusing to overwrite it." >&2
    exit 1
  fi
done

command -v qemu-img >/dev/null
command -v virt-install >/dev/null
command -v cloud-localds >/dev/null
virsh net-info default >/dev/null

if ! sudo test -f "$BASE"; then
  sudo wget -O "${BASE}.download" "$IMAGE_URL"
  sudo mv "${BASE}.download" "$BASE"
fi
sudo qemu-img info "$BASE"
sudo qemu-img create -f qcow2 -F qcow2 -b "$BASE" "$DISK" 24G

USER_DATA=$(mktemp)
trap 'rm -f "$USER_DATA"' EXIT
PUBLIC_KEY=$(<"$PUBLIC_KEY_FILE")
sed "s|REPLACE_WITH_YOUR_PUBLIC_SSH_KEY|$PUBLIC_KEY|" \
  "$SCRIPT_DIR/user-data.yaml" > "$USER_DATA"

sudo cloud-localds "$SEED" "$USER_DATA" "$SCRIPT_DIR/meta-data.yaml"
sudo chown libvirt-qemu:kvm "$BASE" "$DISK" "$SEED"
sudo chmod 0640 "$BASE" "$DISK" "$SEED"

sudo virt-install \
  --connect qemu:///system \
  --name "$VM" \
  --memory 2048,maxmemory=4096 \
  --vcpus 2,maxvcpus=4 \
  --cpu host-model \
  --osinfo ubuntu24.04 \
  --import \
  --disk path="$DISK",format=qcow2,bus=virtio \
  --disk path="$SEED",device=cdrom \
  --network network=default,model=virtio \
  --graphics none \
  --console pty,target_type=serial \
  --channel unix,target.type=virtio,target.name=org.qemu.guest_agent.0 \
  --noautoconsole

virsh autostart "$VM"
virsh list --all
virsh domifaddr "$VM" --source lease || true

echo "Wait for cloud-init, then run ./validate-vm.sh."

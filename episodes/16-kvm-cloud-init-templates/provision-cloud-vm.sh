#!/usr/bin/env bash
set -Eeuo pipefail

name="${1:-}"
mac="${2:-}"
address="${3:-}"
public_key_file="${4:-}"
base="${BASE_IMAGE:-/var/lib/libvirt/cloud-base/ubuntu-24.04-server-cloudimg-amd64.img}"
image_dir="${IMAGE_DIR:-/var/lib/libvirt/images}"
seed_dir="${SEED_DIR:-/var/lib/libvirt/cloud-init}"
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! "$name" =~ ^ep(1[6-9]|20)-[a-z0-9-]+$ || ! "$mac" =~ ^([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}$ || ! "$address" =~ ^192\.168\.122\.[0-9]+$ || ! -s "$public_key_file" ]]; then
  printf 'Usage: %s epNN-NAME MAC 192.168.122.X PUBLIC_KEY_FILE\n' "$0" >&2
  exit 2
fi

virsh dominfo "$name" >/dev/null 2>&1 && {
  printf '%s already exists; no changes made\n' "$name"
  exit 0
}

disk="$image_dir/$name.qcow2"
seed="$seed_dir/$name/$name-seed.iso"
[[ ! -e "$disk" && ! -e "$seed" ]] || {
  printf 'Refusing to overwrite existing storage for %s\n' "$name" >&2
  exit 1
}

sudo install -d -m 0755 "$seed_dir/$name"
public_key="$(<"$public_key_file")"
sed -e "s#__HOSTNAME__#$name#g" -e "s#__SSH_PUBLIC_KEY__#$public_key#g" \
  "$script_dir/user-data.tpl" | sudo tee "$seed_dir/$name/user-data" >/dev/null
sed "s#__HOSTNAME__#$name#g" "$script_dir/meta-data.tpl" |
  sudo tee "$seed_dir/$name/meta-data" >/dev/null
sed -e "s#__MAC__#$mac#g" -e "s#__ADDRESS__#$address#g" \
  "$script_dir/network-config.tpl" | sudo tee "$seed_dir/$name/network-config" >/dev/null

sudo qemu-img create -f qcow2 -F qcow2 -b "$base" "$disk" 8G
sudo cloud-localds --network-config="$seed_dir/$name/network-config" \
  "$seed" "$seed_dir/$name/user-data" "$seed_dir/$name/meta-data"

sudo virt-install \
  --name "$name" \
  --memory 1536 \
  --vcpus 2 \
  --cpu host-passthrough \
  --import \
  --disk "path=$disk,format=qcow2,bus=virtio" \
  --disk "path=$seed,device=cdrom,readonly=on" \
  --network "network=default,model=virtio,mac=$mac" \
  --osinfo ubuntu24.04 \
  --graphics none \
  --console pty,target_type=serial \
  --channel unix,target_type=virtio,name=org.qemu.guest_agent.0 \
  --noautoconsole

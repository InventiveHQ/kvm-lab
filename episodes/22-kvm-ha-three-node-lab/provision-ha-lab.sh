#!/usr/bin/env bash
set -Eeuo pipefail

public_key_file="${1:-}"
[[ -s "$public_key_file" ]] || { printf 'Usage: %s PUBLIC_KEY_FILE\n' "$0" >&2; exit 2; }

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
base="${BASE_IMAGE:-/models/vms/images/ubuntu-26.04-server-cloudimg-amd64.img}"
lab_dir="${LAB_DIR:-/models/vms/labs/ihq-kvm-ha}"
network="${NETWORK:-ihq-kvm-lab}"
public_key="$(<"$public_key_file")"

nodes=(
  'kvm-ha01 192.168.124.21 52:54:00:71:22:01'
  'kvm-ha02 192.168.124.22 52:54:00:71:22:02'
  'kvm-ha03 192.168.124.23 52:54:00:71:22:03'
)

sudo install -d -o libvirt-qemu -g kvm -m 0755 "$lab_dir"

for row in "${nodes[@]}"; do
  read -r name address mac <<< "$row"
  host_xml="<host mac='$mac' name='$name' ip='$address'/>"
  if ! virsh net-dumpxml "$network" | grep -q "ip='$address'\|ip=\"$address\""; then
    virsh net-update "$network" add ip-dhcp-host "$host_xml" --live --config
  fi

  virsh dominfo "$name" >/dev/null 2>&1 && { printf '%s already exists\n' "$name"; continue; }
  disk="$lab_dir/$name.qcow2"
  seed="$lab_dir/$name-seed.iso"
  user_data="$lab_dir/$name-user-data"
  meta_data="$lab_dir/$name-meta-data"
  [[ ! -e "$disk" && ! -e "$seed" ]] || { printf 'Refusing existing storage for %s\n' "$name" >&2; exit 1; }

  sed -e "s#__HOSTNAME__#$name#g" -e "s#__SSH_PUBLIC_KEY__#$public_key#g" \
    "$script_dir/user-data.tpl" | sudo tee "$user_data" >/dev/null
  sed "s#__HOSTNAME__#$name#g" "$script_dir/meta-data.tpl" | sudo tee "$meta_data" >/dev/null
  sudo qemu-img create -f qcow2 -F qcow2 -b "$base" "$disk" 20G
  sudo cloud-localds "$seed" "$user_data" "$meta_data"
  sudo chown libvirt-qemu:kvm "$disk" "$seed"

  virt-install --name "$name" --memory 4096 --vcpus 2 --cpu host-passthrough \
    --import --disk "path=$disk,format=qcow2,bus=virtio" \
    --disk "path=$seed,device=cdrom,readonly=on" \
    --network "network=$network,model=virtio,mac=$mac" --osinfo ubuntu24.04 \
    --graphics none --console pty,target_type=serial \
    --channel unix,target_type=virtio,name=org.qemu.guest_agent.0 --noautoconsole
done

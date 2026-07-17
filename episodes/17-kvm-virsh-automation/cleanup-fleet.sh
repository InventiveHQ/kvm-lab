#!/usr/bin/env bash
set -Eeuo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
inventory="${1:-$script_dir/inventory.tsv}"

while IFS=$'\t' read -r name _; do
  [[ -z "$name" || "$name" == \#* ]] && continue
  if sudo virsh dominfo "$name" >/dev/null 2>&1; then
    sudo virsh destroy "$name" >/dev/null 2>&1 || true
    sudo virsh undefine "$name" --nvram >/dev/null 2>&1 || sudo virsh undefine "$name" >/dev/null
  fi
  sudo rm -f "/var/lib/libvirt/images/$name.qcow2"
  sudo rm -rf "/var/lib/libvirt/cloud-init/$name"
done < "$inventory"

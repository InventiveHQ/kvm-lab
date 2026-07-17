#!/usr/bin/env bash
set -Eeuo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
inventory="${1:-$script_dir/inventory.tsv}"
public_key_file="${2:-}"
provisioner="${PROVISIONER:-$script_dir/../16-kvm-cloud-init-templates/provision-cloud-vm.sh}"

if [[ ! -r "$inventory" || ! -s "$public_key_file" || ! -x "$provisioner" ]]; then
  printf 'Usage: %s INVENTORY.tsv PUBLIC_KEY_FILE\n' "$0" >&2
  exit 2
fi

while IFS=$'\t' read -r name mac address extra; do
  [[ -z "$name" || "$name" == \#* ]] && continue
  [[ -z "$extra" && -n "$mac" && -n "$address" ]] || {
    printf 'Invalid inventory row for %s\n' "$name" >&2
    exit 1
  }
  "$provisioner" "$name" "$mac" "$address" "$public_key_file"
done < "$inventory"

printf '\n%-18s %-12s %-18s %s\n' NAME STATE ADDRESS DISK
while IFS=$'\t' read -r name _ address; do
  [[ -z "$name" || "$name" == \#* ]] && continue
  state="$(sudo virsh domstate "$name" | tr -d '\r')"
  disk="$(sudo virsh domblklist "$name" --details | awk '$2 == "disk" {print $4; exit}')"
  printf '%-18s %-12s %-18s %s\n' "$name" "$state" "$address" "$disk"
done < "$inventory"

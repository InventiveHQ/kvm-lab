#!/usr/bin/env bash
set -Eeuo pipefail

source_domain="${1:-demo-ubuntu01}"
lab_domain="ep11-broken01"
system_disk="/var/lib/libvirt/images/ep11-broken01.qcow2"
data_disk="/var/lib/libvirt/tutorial-data/ep11-broken-data01.qcow2"
missing_disk="/var/lib/libvirt/images/ep11-does-not-exist.qcow2"

if [[ "${2:-}" != "--confirm" ]]; then
  printf 'Usage: %s SOURCE_DOMAIN --confirm\n' "$0" >&2
  exit 2
fi

if virsh dominfo "$lab_domain" >/dev/null 2>&1; then
  printf 'Refusing to overwrite existing domain %s\n' "$lab_domain" >&2
  exit 1
fi

if [[ "$(virsh domstate "$source_domain")" != "shut off" ]]; then
  printf 'Source domain must be shut off for a consistent clone.\n' >&2
  exit 1
fi

sudo virt-clone \
  --original "$source_domain" \
  --name "$lab_domain" \
  --file "$system_disk" \
  --file "$data_disk" \
  --check disk_size=off

virsh dumpxml --inactive "$lab_domain" |
  sed "s#$system_disk#$missing_disk#" |
  sudo virsh define /dev/stdin

printf 'Created intentionally broken disposable domain %s\n' "$lab_domain"


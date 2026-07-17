#!/usr/bin/env bash
set -Eeuo pipefail

domain="${1:-}"
destination_uri="${2:-}"
[[ -n "$domain" && -n "$destination_uri" ]] || {
  printf 'Usage: %s DOMAIN qemu+ssh://USER@HOST/system\n' "$0" >&2
  exit 2
}

printf 'SOURCE\n'
hostnamectl --static
virsh --version
qemu-system-x86_64 --version | head -1
virsh dominfo "$domain"
virsh domblklist "$domain" --details
virsh domiflist "$domain"
df -h /var/lib/libvirt/images

printf '\nDESTINATION\n'
virsh -c "$destination_uri" version
virsh -c "$destination_uri" net-list --all
virsh -c "$destination_uri" pool-list --all

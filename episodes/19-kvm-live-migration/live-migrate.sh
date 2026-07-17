#!/usr/bin/env bash
set -Eeuo pipefail

domain="${1:-}"
destination_uri="${2:-}"
[[ -n "$domain" && -n "$destination_uri" ]] || {
  printf 'Usage: %s DOMAIN qemu+ssh://USER@HOST/system\n' "$0" >&2
  exit 2
}

args=(
  --live
  --persistent
  --undefinesource
  --copy-storage-all
  --verbose
)

if [[ -n "${MIGRATE_DISKS_DETECT_ZEROES:-}" ]]; then
  args+=(--migrate-disks-detect-zeroes "$MIGRATE_DISKS_DETECT_ZEROES")
fi

virsh migrate "${args[@]}" "$domain" "$destination_uri"

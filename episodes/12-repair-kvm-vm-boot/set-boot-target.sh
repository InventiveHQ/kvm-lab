#!/usr/bin/env bash
set -Eeuo pipefail

domain="${1:-}"
target="${2:-}"

if [[ -z "$domain" || ! "$target" =~ ^(emergency|multi-user)\.target$ ]]; then
  printf 'Usage: %s DOMAIN emergency.target|multi-user.target\n' "$0" >&2
  exit 2
fi

[[ "$(virsh domstate "$domain")" == "shut off" ]] || {
  printf '%s must be shut off before offline editing\n' "$domain" >&2
  exit 1
}

sudo virt-customize -d "$domain" \
  --run-command "ln -sfn /usr/lib/systemd/system/$target /etc/systemd/system/default.target"


#!/usr/bin/env bash
set -Eeuo pipefail

domain="ep11-broken01"

if [[ "${1:-}" != "--confirm" ]]; then
  printf 'Usage: %s --confirm\n' "$0" >&2
  exit 2
fi

if ! virsh dominfo "$domain" >/dev/null 2>&1; then
  printf '%s is already absent\n' "$domain"
  exit 0
fi

if [[ "$(virsh domstate "$domain")" != "shut off" ]]; then
  virsh shutdown "$domain"
  for _ in $(seq 1 60); do
    [[ "$(virsh domstate "$domain")" == "shut off" ]] && break
    sleep 2
  done
fi

[[ "$(virsh domstate "$domain")" == "shut off" ]] || {
  printf 'Guest did not shut down; refusing forced cleanup.\n' >&2
  exit 1
}

sudo virsh undefine "$domain" --remove-all-storage


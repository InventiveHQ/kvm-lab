#!/usr/bin/env bash
set -Eeuo pipefail

xml="${1:-/var/lib/libvirt/ha-shared/ha-demo01.xml}"
[[ -r "$xml" ]] || { printf 'Missing shared domain XML: %s\n' "$xml" >&2; exit 1; }

sudo pcs resource create ha-demo01 ocf:heartbeat:VirtualDomain \
  config="$xml" hypervisor="qemu:///system" \
  op start timeout=90s \
  op stop timeout=90s \
  op monitor interval=10s timeout=30s

sudo pcs constraint location ha-demo01 prefers kvm-ha01=100
sudo pcs status --full

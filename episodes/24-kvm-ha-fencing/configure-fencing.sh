#!/usr/bin/env bash
set -Eeuo pipefail

identity_file="${1:-/etc/pacemaker/fence-dell01}"
[[ -r "$identity_file" ]] || { printf 'Missing fencing identity: %s\n' "$identity_file" >&2; exit 1; }

sudo pcs stonith create fence-dell01 fence_virsh \
  ip=192.168.124.1 username=sean identity_file="$identity_file" ssh=true \
  ssh_options='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/tmp/fence-known -o SetEnv=TERM=dumb' \
  command_prompt='\$' \
  pcmk_host_map='kvm-ha01:kvm-ha01;kvm-ha02:kvm-ha02;kvm-ha03:kvm-ha03' \
  pcmk_host_check=static-list \
  op monitor interval=60s timeout=30s

sudo pcs property set stonith-enabled=true
sudo pcs status --full

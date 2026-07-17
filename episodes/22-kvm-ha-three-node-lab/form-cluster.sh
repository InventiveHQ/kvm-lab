#!/usr/bin/env bash
set -Eeuo pipefail

password_file="${1:-}"
[[ -s "$password_file" ]] || { printf 'Usage: %s TEMPORARY_PASSWORD_FILE\n' "$0" >&2; exit 2; }
password="$(<"$password_file")"

sudo pcs host auth \
  kvm-ha01 addr=192.168.124.21 \
  kvm-ha02 addr=192.168.124.22 \
  kvm-ha03 addr=192.168.124.23 \
  -u hacluster -p "$password"

sudo pcs cluster setup ihq-kvm-ha \
  kvm-ha01 addr=192.168.124.21 \
  kvm-ha02 addr=192.168.124.22 \
  kvm-ha03 addr=192.168.124.23 \
  --start --enable --wait=60

# Episode 24 must replace this temporary teaching state with tested fencing.
sudo pcs property set stonith-enabled=false
sudo pcs property set no-quorum-policy=stop
sudo pcs status
sudo corosync-quorumtool -s

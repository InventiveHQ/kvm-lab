#!/usr/bin/env bash
set -Eeuo pipefail

domain="${1:-}"
guest_address="${2:-}"
private_key="${3:-}"
[[ -n "$domain" && -n "$guest_address" && -s "$private_key" ]] || {
  printf 'Usage: %s DOMAIN GUEST_ADDRESS PRIVATE_KEY\n' "$0" >&2
  exit 2
}

ssh_opts=(
  -o BatchMode=yes
  -o StrictHostKeyChecking=no
  -o UserKnownHostsFile=/tmp/ep20-known-hosts
  -i "$private_key"
)
guest=(ssh "${ssh_opts[@]}" "ihq@$guest_address")
tap="$(virsh domiflist "$domain" | awk '$2 == "network" {print $1; exit}')"
[[ -n "$tap" ]] || { printf 'No libvirt network interface found\n' >&2; exit 1; }

printf '=== BASELINE ===\n'
virsh domstats "$domain" --vcpu --balloon
virsh domblkstat "$domain" vda --human
virsh domifstat "$domain" "$tap"
"${guest[@]}" 'uptime; cat /proc/loadavg; ip -s link show'

printf '\n=== BOUNDED CPU SYMPTOM ===\n'
"${guest[@]}" 'timeout 10 sh -c "yes >/dev/null"' || [[ $? -eq 124 ]]
virsh domstats "$domain" --vcpu
"${guest[@]}" 'cat /proc/loadavg'

printf '\n=== BOUNDED DISK SYMPTOM ===\n'
virsh domblkstat "$domain" vda --human
"${guest[@]}" 'dd if=/dev/zero of=/tmp/ep20-io.bin bs=4M count=64 conv=fdatasync status=none; sync; rm -f /tmp/ep20-io.bin'
virsh domblkstat "$domain" vda --human

printf '\n=== BOUNDED NETWORK SYMPTOM ===\n'
"${guest[@]}" 'sudo dd if=/dev/zero of=/var/lib/ep20-net.bin bs=1M count=64 status=none'
virsh domifstat "$domain" "$tap"
curl -fsS "http://$guest_address:8080/ep20-net.bin" >/dev/null
virsh domifstat "$domain" "$tap"
"${guest[@]}" 'sudo rm -f /var/lib/ep20-net.bin; ip -s link show'

printf '\n=== RECOVERY ===\n'
"${guest[@]}" 'pgrep -af "yes|dd.*ep20" || true; test ! -e /tmp/ep20-io.bin; test ! -e /var/lib/ep20-net.bin; cat /proc/loadavg'
virsh domstate "$domain"

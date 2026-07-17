#!/usr/bin/env bash
set -Eeuo pipefail

guest_address="${1:-192.168.122.81}"
destination_host="${2:-192.168.124.125}"
destination_key="${3:-/tmp/ep18-host-key}"
samples="${4:-120}"

for _ in $(seq 1 "$samples"); do
  timestamp="$(date +%s.%N)"
  if curl -fsS --max-time 0.7 "http://$guest_address:8080/ihq-migration-proof" >/dev/null 2>&1; then
    printf '%s source ok\n' "$timestamp"
  elif ssh -o BatchMode=yes -o ConnectTimeout=1 -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/tmp/ep19-probe-known -i "$destination_key" \
    "$destination_host" "curl -fsS --max-time 0.7 http://$guest_address:8080/ihq-migration-proof" \
    >/dev/null 2>&1; then
    printf '%s destination ok\n' "$timestamp"
  else
    printf '%s unavailable\n' "$timestamp"
  fi
  sleep 1
done

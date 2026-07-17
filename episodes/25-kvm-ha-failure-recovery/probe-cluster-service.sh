#!/usr/bin/env bash
set -Eeuo pipefail

key="${1:-}"
samples="${2:-180}"
[[ -s "$key" ]] || { printf 'Usage: %s CLUSTER_SSH_KEY [SAMPLES]\n' "$0" >&2; exit 2; }

for _ in $(seq 1 "$samples"); do
  timestamp="$(date +%s.%N)"
  result=unavailable
  for address in 192.168.124.21 192.168.124.22 192.168.124.23; do
    if ssh -o BatchMode=yes -o ConnectTimeout=1 -o StrictHostKeyChecking=no \
      -o UserKnownHostsFile=/tmp/ep25-known -i "$key" "ihq@$address" \
      'curl -fsS --max-time 0.7 http://192.168.122.74:8080/ha-demo-proof' \
      >/dev/null 2>&1; then
      result="$address ok"
      break
    fi
  done
  printf '%s %s\n' "$timestamp" "$result"
  sleep 1
done

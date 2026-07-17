#!/usr/bin/env bash
set -Eeuo pipefail

node="${1:-}"
[[ "$node" =~ ^kvm-ha0[1-3]$ ]] || { printf 'Usage: %s kvm-ha0N\n' "$0" >&2; exit 2; }

sudo pcs node standby "$node"
sudo pcs status wait 120
sudo pcs status --full
printf '%s is ready for scoped patching and reboot.\n' "$node"
printf 'After the node rejoins, run: sudo pcs node unstandby %s\n' "$node"

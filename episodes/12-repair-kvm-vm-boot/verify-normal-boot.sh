#!/usr/bin/env bash
set -Eeuo pipefail

domain="${1:-ep12-rescue01}"
virsh domstate "$domain"
virsh domblklist "$domain" --details
virsh qemu-agent-command "$domain" '{"execute":"guest-ping"}'


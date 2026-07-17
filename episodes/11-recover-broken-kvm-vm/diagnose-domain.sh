#!/usr/bin/env bash
set -Eeuo pipefail

domain="${1:-ep11-broken01}"

virsh domstate "$domain"
virsh dominfo "$domain"
virsh domblklist "$domain" --details
virsh dumpxml --inactive "$domain"

printf '\nRecent libvirt service errors:\n'
sudo journalctl -u libvirtd -u virtqemud --since '-5 minutes' --no-pager |
  tail -n 80


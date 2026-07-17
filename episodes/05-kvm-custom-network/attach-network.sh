#!/usr/bin/env bash
set -euo pipefail

export LIBVIRT_DEFAULT_URI=${LIBVIRT_DEFAULT_URI:-qemu:///system}
VM=${1:-demo-ubuntu01}
MAC=52:54:00:77:05:01

virsh dominfo "$VM" >/dev/null
if virsh dumpxml "$VM" | grep -qi "$MAC"; then
  echo "$MAC is already attached to $VM; inspect it first." >&2
  exit 1
fi

virsh attach-interface "$VM" network tutorial-net \
  --model virtio --mac "$MAC" --live --config
virsh domiflist "$VM"
virsh net-dhcp-leases tutorial-net
virsh domifaddr "$VM" --source agent || true

cat <<'EOF'
Inside Ubuntu, match the new interface to MAC 52:54:00:77:05:01, then install
60-tutorial-net.yaml using that interface name. Validate with:
  sudo chmod 600 /etc/netplan/60-tutorial-net.yaml
  sudo netplan generate
  sudo netplan apply
EOF

#!/usr/bin/env bash
set -euo pipefail

export LIBVIRT_DEFAULT_URI=${LIBVIRT_DEFAULT_URI:-qemu:///system}
VM=${1:-demo-ubuntu01}

virsh net-info tutorial-net
virsh net-dhcp-leases tutorial-net
virsh domiflist "$VM"
virsh domifaddr "$VM" --source agent
virsh dumpxml "$VM" --inactive | grep -A8 -B2 'tutorial-net'

cat <<'EOF'
Inside Ubuntu verify:
  ip -brief address
  ip route show default
  ip route get 1.1.1.1
  ping -c 2 -I 192.168.150.10 192.168.150.1
EOF

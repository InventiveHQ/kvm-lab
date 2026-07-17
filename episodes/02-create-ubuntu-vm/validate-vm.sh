#!/usr/bin/env bash
set -euo pipefail

export LIBVIRT_DEFAULT_URI=qemu:///system
VM=demo-ubuntu01

virsh list --all
virsh dominfo "$VM"
virsh domifaddr "$VM" --source lease
virsh domifaddr "$VM" --source agent || true
virsh ttyconsole "$VM"
virsh vcpucount "$VM"
virsh dominfo "$VM" | grep -E '^(Autostart|CPU\(s\)|Max memory|Used memory)'
virsh dumpxml "$VM" --inactive | grep -E '<(memory|currentMemory|vcpu)'

echo "For guest-side verification, SSH to the lease address and run:"
echo "  cloud-init status --wait"
echo "  systemctl is-active qemu-guest-agent"
echo "  systemctl is-enabled serial-getty@ttyS0.service"

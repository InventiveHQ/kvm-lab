#!/usr/bin/env bash
set -euo pipefail

export LIBVIRT_DEFAULT_URI=${LIBVIRT_DEFAULT_URI:-qemu:///system}
VM=${1:-demo-ubuntu01}

virsh dominfo "$VM"
virsh vcpucount "$VM"
virsh dumpxml "$VM" --inactive > "${VM}-before.xml"

virsh setvcpus "$VM" 4 --live --config
virsh setmem "$VM" 4096MiB --live --config

virsh dominfo "$VM"
virsh vcpucount "$VM"
virsh dumpxml "$VM" --inactive | grep -E '<(memory|currentMemory|vcpu)'

cat <<'EOF'
Verify inside the Ubuntu guest:
  nproc
  grep -E 'MemTotal|MemAvailable' /proc/meminfo
  lscpu -e=CPU,ONLINE

If hot-added CPUs are present but offline, review and run inside the guest:
  for cpu in /sys/devices/system/cpu/cpu*/online; do [ "$(cat "$cpu")" = 0 ] && echo 1 | sudo tee "$cpu"; done
EOF

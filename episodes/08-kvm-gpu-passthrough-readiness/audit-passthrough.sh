#!/usr/bin/env bash
set -euo pipefail

echo '== CPU virtualization =='
lscpu | grep -E 'Model name|Virtualization|Socket|NUMA' || true

echo '== Running kernel command line =='
cat /proc/cmdline

echo '== IOMMU boot log =='
sudo dmesg | grep -Ei 'DMAR|IOMMU' || true

echo '== IOMMU group count =='
group_count=$(find /sys/kernel/iommu_groups -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
echo "$group_count"

echo '== Display-class PCI devices and drivers =='
lspci -nnk | grep -A3 -Ei 'VGA|3D|Display' || true

if (( group_count == 0 )); then
  echo 'NO-GO: no IOMMU isolation groups are available. No device was detached.' >&2
  exit 4
fi

echo 'Groups exist. Audit every sibling and host dependency before VFIO binding.'

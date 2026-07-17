# Episode 8 commands

```bash
lscpu | grep -E 'Model name|Virtualization|Socket|NUMA'
cat /proc/cmdline
sudo dmesg | grep -Ei 'DMAR|IOMMU'
find /sys/kernel/iommu_groups -mindepth 1 -maxdepth 1 -type d | wc -l
lspci -nnk | grep -A3 -Ei 'VGA|3D|Display'
virsh nodedev-list --cap pci
virsh nodedev-dumpxml pci_0000_0b_00_0
readlink -f /sys/bus/pci/devices/0000:0b:00.0/iommu_group
```

Only on a passing host, list every function in the target group and preserve a
tested rollback path before any `virsh nodedev-detach` or VFIO binding.

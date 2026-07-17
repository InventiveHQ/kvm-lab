# Episode 8: KVM GPU passthrough readiness

Audit CPU virtualization, firmware and kernel IOMMU state, isolation groups,
PCI function ownership, and libvirt node-device identity before touching VFIO.

- Series index: https://inventivehq.com/blog/kvm-virtualization-series
- Virsh Command Builder: https://inventivehq.com/tools/developer/virsh-command-builder
- Release tag: `episode-08-v1`
- Previous episode: `../07-kvm-cloning-templates/`

`audit-passthrough.sh` is intentionally read-only. A no-go result is valid. Do
not detach a device when the IOMMU is disabled, its isolation group is missing
or unsafe, or the host depends on that device for console, storage, or network
access.

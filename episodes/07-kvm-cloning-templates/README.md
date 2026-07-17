# Episode 7: Clone KVM VMs without duplicating identity

Clone the source disks and libvirt definition, then reset the hostname, machine
ID, SSH host keys, cloud-init state, MAC-pinned Netplan configuration, UUID,
MAC addresses, and IP addresses.

- Series index: https://inventivehq.com/blog/kvm-virtualization-series
- Virsh Command Builder: https://inventivehq.com/tools/developer/virsh-command-builder
- Release tag: `episode-07-v1`
- Previous episode: `../06-kvm-snapshots-backup-restore/`

Run `clone-vm.sh` only against a shut-off disposable source. It prints the
generated XML before copying data and requires an explicit confirmation value.
Review the generated clone MAC before applying any Netplan replacement.

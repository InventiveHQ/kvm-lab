# Episode assets

Every published episode folder will contain:

- A README linking the video and companion article
- Commands or scripts in the order demonstrated
- Configuration templates with safe placeholders
- Expected output where it aids verification
- Cleanup and rollback guidance
- The release tag used by the video description

The complete command list will also remain in the YouTube description and the
companion article so the repository is a convenience, not a dependency.

## Published series

1. [`01-install-kvm-on-ubuntu`](01-install-kvm-on-ubuntu/) — prepare and verify
   the KVM/libvirt host.
2. [`02-create-ubuntu-vm`](02-create-ubuntu-vm/) — create an Ubuntu cloud-image
   guest with SSH, guest-agent, and serial-console access.
3. [`03-manage-kvm-with-virsh`](03-manage-kvm-with-virsh/) — inspect, resize,
   recover, and safely retire the guest with `virsh`.
4. [`04-kvm-storage-pools-volumes`](04-kvm-storage-pools-volumes/) — create a
   persistent pool and volume, attach it, and expand its filesystem online.
5. [`05-kvm-custom-network`](05-kvm-custom-network/) — add a custom NAT network,
   fixed DHCP lease, second guest NIC, and controlled route priority.

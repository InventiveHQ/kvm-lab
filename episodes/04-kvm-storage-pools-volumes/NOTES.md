# Validation and safety notes

- Validated July 16, 2026 with libvirt 12.0.0, QEMU 10.2.1, and an Ubuntu 24.04
  LTS guest.
- This episode expands storage only. Shrinking is not the reverse operation and
  can destroy data.
- Formatting is deliberately excluded from the host automation. Reconcile the
  new host attachment with the guest device before running `mkfs`.
- A disk with partitions, LVM, XFS, or encryption needs different guest-side
  expansion steps.
- Detaching a disk does not delete its volume. Keep deletion separate and
  explicit.

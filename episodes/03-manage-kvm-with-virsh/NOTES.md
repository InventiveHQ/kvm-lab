# Validation and safety notes

- Validated July 16, 2026 on Ubuntu 26.04 LTS, libvirt 12.0.0, QEMU 10.2.1,
  and the Ubuntu 24.04 LTS guest created in Episode 2.
- Live and persistent CPU/memory changes were verified separately.
- Newly hot-added Linux CPUs can remain offline until the guest onlines them.
- `shutdown` asks the guest to stop cleanly. `destroy` is an immediate virtual
  power cut and can cause data loss.
- Plain `undefine` preserves disks. `undefine --remove-all-storage` can delete
  attached managed storage and must be preceded by a storage inventory and
  backup check.
- Persistent XML exports can contain identifiers and environment details;
  sanitize them before sharing.

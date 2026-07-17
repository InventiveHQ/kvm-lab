# Validation and safety notes

- Validated July 16, 2026 on an Ubuntu 26.04 LTS KVM host with libvirt 12.0.0
  and QEMU 10.2.1; the guest is Ubuntu 24.04 LTS.
- The demonstrated lab guest is `demo-ubuntu01`.
- Never commit a real private key. `user-data.yaml` intentionally contains a
  public-key placeholder.
- The `current` Ubuntu cloud-image URL changes over time. Production image
  pipelines should pin and verify a published checksum.
- The qcow2 overlay depends on its base image. Do not move or delete the base
  while overlays reference it.
- Do not disable AppArmor or make libvirt image directories world writable to
  bypass an ownership or path error.

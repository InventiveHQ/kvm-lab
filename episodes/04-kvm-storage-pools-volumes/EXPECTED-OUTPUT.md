# Expected output

- `tutorial-data` reports running, persistent, and autostarting.
- A new 5 GiB qcow2 volume initially allocates only a few hundred KiB.
- `domblklist` maps the volume to `vdb` in `demo-ubuntu01`.
- The guest sees an empty 5 GiB `/dev/vdb`, then an approximately 4.9 GiB ext4
  filesystem after formatting.
- `vol-resize` against the attached active qcow2 volume is rejected because
  QEMU holds the write lock. `blockresize demo-ubuntu01 vdb 8GiB` succeeds.
- After guest `resize2fs`, `df` reports approximately 7.8 GiB and the validation
  file remains readable.

Allocation and usable filesystem capacity vary slightly by filesystem and host.

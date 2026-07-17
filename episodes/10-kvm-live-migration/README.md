# Episode 10: Live migration with non-shared storage

Live-migrate a running two-disk guest from host01 to host02 with matching
networks and destination paths, a full storage copy, persistent destination
definition, and source undefinition after success.

- Series index: https://inventivehq.com/blog/kvm-virtualization-series
- Virsh Command Builder: https://inventivehq.com/tools/developer/virsh-command-builder
- Release tag: `episode-10-v1`
- Previous episode: `../09-kvm-performance-tuning/`

Run `preflight-migration.sh` from the source host. It is read-only. Do not run
the migration until remote libvirt access, versions, CPU compatibility,
network names, pool paths, capacity, and destination name availability all
pass.

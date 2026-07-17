# Episode 18: Migrate a KVM VM to another host

This lab performs an offline migration only after checking hypervisor versions,
CPU compatibility, destination capacity, networks, and the guest's complete
disk chain. It preserves a rollback copy until destination verification passes.

- Release tag: `episode-18-v1`
- Series index: https://inventivehq.com/blog/kvm-virtualization-series

Never leave the same domain defined on both hosts against writable copies of
the same storage. The scripts stop on missing prerequisites and do not delete
rollback data automatically.

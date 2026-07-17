# Episode 14: Build isolated KVM lab networks

Create persistent application and database segments without a forwarding mode,
attach temporary guest interfaces, prove permitted segment-local traffic, and
prove the database interface has no WAN path.

- Release tag: `episode-14-v1`
- Series index: https://inventivehq.com/blog/kvm-virtualization-series

`app-net` supplies deterministic DHCP. `db-net` intentionally has no DHCP and
uses explicit addressing. Neither XML definition contains `<forward>`, so
libvirt does not route either segment outside its host.


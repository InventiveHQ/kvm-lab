# Episode 13: Give a KVM VM direct LAN access with a bridge

Attach a temporary virtio interface to an existing Linux bridge, obtain a LAN
address without moving the management path, prove two-way reachability, and
remove the live-only interface.

- Release tag: `episode-13-v1`
- Series index: https://inventivehq.com/blog/kvm-virtualization-series

The validated lab used the existing `br0`; it did not modify the host bridge,
default route, or persistent VM definition. Discover names and addresses in
your own environment instead of copying the examples.


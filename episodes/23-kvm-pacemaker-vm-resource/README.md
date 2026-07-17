# Episode 23: Add a KVM virtual machine to Pacemaker

Mount the same teaching-only NFS path on all three nodes, place the guest disk
and XML there, and let Pacemaker become the only domain owner. Move the resource
cleanly and prove that exactly one node runs it at every checkpoint.

- Release tag: `episode-23-v1`
- Series index: https://inventivehq.com/blog/kvm-virtualization-series

The NFS server is intentionally a single point of failure for Episodes 23–25.
It must not be described as redundant and is replaced in Episode 26.

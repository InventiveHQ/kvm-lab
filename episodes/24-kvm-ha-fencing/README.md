# Episode 24: Configure fencing and prove split-brain protection

The outer hypervisor is the independent power authority for all three nested
nodes. Validate status for every mapped plug, enable STONITH, and fence a
non-active node before testing the active guest owner.

- Release tag: `episode-24-v1`
- Series index: https://inventivehq.com/blog/kvm-virtualization-series

`TERM=dumb` is intentional: Ubuntu's interactive shell markers otherwise
pollute `fence_virsh` output parsing. Never enable automated recovery with an
untested or self-hosted fence device.

# Episode 26: Remove the KVM HA storage single point of failure

Replace the single outer-host NFS export with a three-brick Gluster replica.
Move the stopped guest storage, update its shared XML, and resume Pacemaker
ownership. Fail one non-owner storage/compute node while the workload runs and
verify the service and proof data before rejoining it.

- Release tag: `episode-26-v1`
- Series index: https://inventivehq.com/blog/kvm-virtualization-series

This removes the demonstrated single storage-server failure, not every
correlated failure. All bricks still share one physical outer hypervisor and
one lab network; production designs must separate those failure domains.

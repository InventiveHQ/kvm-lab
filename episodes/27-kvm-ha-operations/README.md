# Episode 27: Operate and maintain a KVM HA cluster

Put one non-owner node in standby, patch and reboot it, return it intentionally,
then replace its outer libvirt definition from reviewed XML while preserving
the scoped node disk. End with quorum, resource, fencing, storage-heal, service,
and failure-history checks.

- Release tag: `episode-27-v1`
- Series index: https://inventivehq.com/blog/kvm-virtualization-series

Standby and maintenance modes solve different problems. Never clear a failure
without first identifying it, and never delete fencing history merely to make a
status screen look clean.

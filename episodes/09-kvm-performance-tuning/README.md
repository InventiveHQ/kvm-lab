# Episode 9: Measure-first KVM performance tuning

Inventory CPU, NUMA, and huge-page capacity, capture live domain counters,
benchmark a bounded guest file, apply a live disk limit, and prove rollback.

- Series index: https://inventivehq.com/blog/kvm-virtualization-series
- Virsh Command Builder: https://inventivehq.com/tools/developer/virsh-command-builder
- Release tag: `episode-09-v1`
- Previous episode: `../08-kvm-gpu-passthrough-readiness/`

The lab intentionally rejects CPU pinning and huge pages because the four-vCPU
guest already consumes a four-CPU host and the host has no reserved huge pages.
The demonstrated change is a live, reversible 20 MiB/s limit on `vdb`.

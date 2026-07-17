# Episode 11: Recover a broken KVM virtual machine

Reproduce a safe domain start failure in a disposable clone, find the first
causal storage error, repair the inactive XML, and prove the guest starts.

- Series index: https://inventivehq.com/blog/kvm-virtualization-series
- Virsh Command Builder: https://inventivehq.com/tools/developer/virsh-command-builder
- Release tag: `episode-11-v1`
- Previous episode: `../10-kvm-live-migration/`

`diagnose-domain.sh` is read-only. `build-broken-lab.sh` and `cleanup.sh` are
deliberately scoped to `ep11-broken01`; review them before using a disposable
lab. The source guest must be shut off while `virt-clone` copies it.


# Episode 12: Repair a VM that will not boot

Use a disposable clone to reproduce a guest that enters emergency mode, prove
normal guest services never become ready, repair its boot target offline with
libguestfs, and validate a normal boot.

- Series index: https://inventivehq.com/blog/kvm-virtualization-series
- Virsh Command Builder: https://inventivehq.com/tools/developer/virsh-command-builder
- Release tag: `episode-12-v1`
- Previous episode: `../11-recover-broken-kvm-vm/`

The scripts only target `ep12-rescue01`. Review them before use. The source
guest must be shut off while it is cloned, and offline editing requires the
clone to remain shut off.


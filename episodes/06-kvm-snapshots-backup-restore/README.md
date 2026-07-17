# Episode 6: KVM snapshots, backup, and tested restore

Create one atomic, quiesced external checkpoint across both writable disks,
convert the frozen bases into standalone backups, boot an isolated restore,
and merge each live overlay to an explicitly named immediate base.

- Series index: https://inventivehq.com/blog/kvm-virtualization-series
- Virsh Command Builder: https://inventivehq.com/tools/developer/virsh-command-builder
- Release tag: `episode-06-v1`
- Previous episode: `../05-kvm-custom-network/`

Read `COMMANDS.md` before running `snapshot-backup.sh`. The script refuses to
run unless `CONFIRM_DISPOSABLE_LAB=demo-ubuntu01` is set. A snapshot is not an
independent backup, and the restore test must remain network-isolated.

The merge commands name `--base` explicitly. Omitting it on a multi-level
backing chain can collapse more layers than intended.

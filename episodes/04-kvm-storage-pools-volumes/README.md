# Episode 4: KVM storage pools, volumes, and disk expansion

Create a persistent directory storage pool, allocate a sparse qcow2 data
volume, attach it to the running `demo-ubuntu01` guest, and expand the active
device from 5 GiB to 8 GiB.

- Series index: https://inventivehq.com/blog/kvm-virtualization-series
- Companion article: https://inventivehq.com/blog/kvm-storage-pools-volumes-expand-disks
- Virsh Command Builder: https://inventivehq.com/tools/developer/virsh-command-builder
- Release tag: `episode-04-v1`
- Previous episode: `../03-manage-kvm-with-virsh/`
- Next episode: `../05-kvm-custom-network/`

## Workflow

```bash
./create-storage.sh
```

The script stops on an existing pool, volume, or `vdb` attachment. It creates
host-side resources only and prints the guest-side formatting commands for
review. Formatting is never automatic because the guest must prove the target
is the new empty disk first.

After formatting and mounting `/dev/vdb` inside Ubuntu, expand the attached
device:

```bash
./resize-active-disk.sh
./validate-storage.sh
```

Review `COMMANDS.md` and `EXPECTED-OUTPUT.md` for the complete sequence,
including online ext4 expansion and the active qcow2 write-lock behavior.

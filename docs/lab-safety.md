# KVM lab safety

Use a disposable host or an isolated nested-virtualization environment. Do not
test destructive commands against production workloads.

Before changing a guest:

1. Confirm the libvirt connection URI and host.
2. Confirm the VM name or UUID.
3. Record `virsh dominfo`, `virsh domblklist`, and the inactive XML definition.
4. Verify whether each operation affects the live guest, persistent definition,
   storage, or all three.
5. Maintain a real backup for data that matters. An XML export is not a disk
   backup, and a snapshot is not automatically a backup.

Commands that use `destroy`, `undefine`, `--remove-all-storage`, disk conversion,
or network reconfiguration require additional review.


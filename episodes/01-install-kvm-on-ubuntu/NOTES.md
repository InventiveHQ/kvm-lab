# Operator notes, rollback, and cleanup

## Security boundary

Membership in `libvirt` and access to `/dev/kvm` are privileged capabilities.
On a typical host, a libvirt administrator can create guests with host-backed
storage and devices. Add only trusted administrators and follow the host's
normal access-review process.

The examples use `qemu:///system`, whose guests and networks are managed by the
system libvirt daemon. It is deliberately different from `qemu:///session`,
which manages per-user guests and has different networking and permissions.

## No automatic removal script

This directory intentionally does not contain an uninstall script. Package
removal can affect guests, networks, storage pools, and other applications that
were created after Episode 01. Before rollback, record at least:

```bash
virsh --connect qemu:///system list --all
virsh --connect qemu:///system net-list --all
virsh --connect qemu:///system pool-list --all
```

If this is still a disposable, empty host, an administrator can review removal
with APT's simulation mode:

```bash
sudo apt-get --simulate purge cpu-checker qemu-system-x86 libvirt-daemon-system libvirt-clients virtinst
```

Read the complete proposed package list before omitting `--simulate`. Do not
delete `/var/lib/libvirt`, disk images, or network definitions as a generic
cleanup step.

To revoke account access without uninstalling the host, first confirm the user
has no active virtualization work, then remove only the group memberships:

```bash
sudo deluser USERNAME libvirt
sudo deluser USERNAME kvm
```

The user must sign out and back in before the revoked memberships disappear
from the login session.

## Lab continuity

The series keeps its host, networks, guests, and disks between episodes. Do not
clean up Episode 01 resources if you are continuing to Episode 02. The final
series cleanup will inventory dependencies before anything is removed.

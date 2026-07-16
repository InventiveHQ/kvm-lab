# Expected output

Versions and device ownership vary by update level. The important results are
the states shown below, not exact version numbers or spacing.

## Hardware check

```text
INFO: /dev/kvm exists
KVM acceleration can be used
```

`kvm-ok` may suggest loading a KVM kernel module when virtualization is disabled
in firmware or not exposed to a nested VM. Fix that before continuing.

## Service and connection

```text
$ systemctl is-active libvirtd
active

$ virsh --connect qemu:///system uri
qemu:///system
```

On the validated Ubuntu 26.04 lab, `virsh version` reported libvirt 12 and QEMU
10.2. Patch versions can change through normal Ubuntu updates.

An empty guest table is correct on a newly installed host:

```text
 Id   Name   State
--------------------
```

## Default network

```text
$ virsh --connect qemu:///system net-info default
Name:           default
Active:         yes
Persistent:     yes
Autostart:      yes
Bridge:         virbr0
```

The UUID is intentionally omitted because every host generates a different
value. The bridge name may also differ if the network definition was customized.

## Host validation

The core KVM checks should pass. A nested or non-confidential-computing lab may
warn about IOMMU or secure-guest support. Those features are important for the
workloads that require them, but their absence does not by itself prevent an
ordinary KVM guest from running.

Investigate any `FAIL` result. Do not dismiss warnings about the KVM device,
hardware virtualization, cgroups, or QEMU security isolation.

## Common permission error

```text
error: failed to connect to the hypervisor
error: Failed to connect socket to '/var/run/libvirt/libvirt-sock': Permission denied
```

After adding the account to `libvirt` and `kvm`, completely sign out and back in.
Running `id` should then list both groups. `newgrp` changes only one primary group
for a subshell and is not used in this episode's durable setup.

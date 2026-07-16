# Episode 01 commands

These are the commands demonstrated in the video. Run them individually if you
want to follow the explanation, or use the scripts in this directory for an
idempotent workflow.

## 1. Check hardware virtualization

```bash
grep -E -m1 '(^|[[:space:]])(vmx|svm)([[:space:]]|$)' /proc/cpuinfo
ls -l /dev/kvm
```

After installing `cpu-checker`, the concise check is:

```bash
kvm-ok
```

## 2. Install KVM, QEMU, libvirt, and virt-install

```bash
sudo apt update
sudo apt install -y cpu-checker qemu-system-x86 libvirt-daemon-system libvirt-clients virtinst
```

## 3. Enable and inspect libvirt

```bash
sudo systemctl enable --now libvirtd
systemctl is-active libvirtd
virsh --connect qemu:///system version
```

## 4. Grant your account access

Membership in `libvirt` permits privileged virtualization management. Add only
trusted administrator accounts.

```bash
sudo adduser "$USER" libvirt
sudo adduser "$USER" kvm
```

Sign out and back in before continuing. In an SSH session, disconnect and
reconnect. Confirm the refreshed memberships:

```bash
id
virsh --connect qemu:///system list --all
```

## 5. Start the default NAT network

Inspect its state first:

```bash
virsh --connect qemu:///system net-list --all
```

If `default` is inactive, start it. Starting an already active network returns
an error, so this command is conditional:

```bash
virsh --connect qemu:///system net-start default
```

Make the network start with the host and inspect it:

```bash
virsh --connect qemu:///system net-autostart default
virsh --connect qemu:///system net-info default
```

## 6. Validate the host

```bash
sudo virt-host-validate qemu
virsh --connect qemu:///system uri
ls -ld /var/lib/libvirt/images
```

`virt-host-validate` can report warnings for features the host does not use,
such as secure guests or IOMMU. Review each warning in context rather than
assuming every warning prevents ordinary KVM guests.

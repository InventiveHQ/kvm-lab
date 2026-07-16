# Episode 01: Install KVM on Ubuntu

Build and validate a KVM/libvirt virtualization host on Ubuntu. This episode
stops at a ready host; the first guest is created in Episode 02.

- Companion article: <https://inventivehq.com/blog/install-kvm-on-ubuntu>
- Command builder: <https://inventivehq.com/tools/developer/virsh-command-builder>
- Tested lab: Ubuntu 26.04 LTS (amd64), libvirt's `qemu:///system` URI

The package name used here is `qemu-system-x86`. Ubuntu 26.04 does not provide
the older `qemu-kvm` installation candidate used by some earlier tutorials.

## Files

| File | Purpose |
| --- | --- |
| [`COMMANDS.md`](COMMANDS.md) | Every command from the episode, in order |
| [`check-kvm-support.sh`](check-kvm-support.sh) | Non-destructive CPU and `/dev/kvm` preflight |
| [`install-kvm.sh`](install-kvm.sh) | Idempotent package, service, group, and network setup |
| [`verify-kvm-host.sh`](verify-kvm-host.sh) | Read-only post-install verification |
| [`EXPECTED-OUTPUT.md`](EXPECTED-OUTPUT.md) | Example output and acceptable warnings |
| [`NOTES.md`](NOTES.md) | Security, rollback, and cleanup guidance |

## Quick start

Review each script before running it. Use a disposable lab rather than a
production host.

```bash
cd episodes/01-install-kvm-on-ubuntu
./check-kvm-support.sh
sudo ./install-kvm.sh "$USER"
```

Sign out and back in so the new `libvirt` and `kvm` memberships apply, then
verify access without `sudo`:

```bash
./verify-kvm-host.sh
```

The install script starts and enables the libvirt service. If the packaged
`default` NAT network exists, it also starts it and enables autostart. It never
creates, changes, or deletes a virtual machine or disk image.

## Expected end state

- KVM acceleration is available through `/dev/kvm`.
- `libvirtd` is active.
- Your account belongs to `libvirt` and `kvm`.
- `virsh --connect qemu:///system` reaches the system libvirt daemon.
- The `default` libvirt network is active and set to autostart.

See [`EXPECTED-OUTPUT.md`](EXPECTED-OUTPUT.md) when output differs. Hardware
virtualization must be enabled in firmware, and nested labs must expose Intel
VT-x or AMD-V to the guest.

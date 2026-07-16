# Inventive HQ KVM Lab

Tested scripts, cloud-init templates, commands, and companion assets for the
[Inventive HQ](https://inventivehq.com) KVM and `virsh` video series.

Each episode has a self-contained folder with the files required to reproduce
the lesson. The matching article remains the detailed source for prerequisites,
expected output, troubleshooting, and rollback instructions.

## Series structure

| Episode | Topic | Assets |
| --- | --- | --- |
| 01 | Install KVM and libvirt on Ubuntu | [`episodes/01-install-kvm-on-ubuntu`](episodes/01-install-kvm-on-ubuntu) |
| 02 | Manage a KVM virtual machine with virsh | [`episodes/02-manage-kvm-with-virsh`](episodes/02-manage-kvm-with-virsh) |

Additional episode folders will be published with the corresponding videos.

## Download

Clone the entire lab:

```bash
git clone https://github.com/InventiveHQ/kvm-lab.git
cd kvm-lab
```

For a published video, use the tag linked from its companion article and video
description. A tag preserves the exact scripts demonstrated in that episode.

## Safety

These files create, modify, and sometimes remove virtual machines, networks,
and disk images. Read every script before running it. Use a disposable lab and
verify VM names and storage paths before approving destructive operations.

See [`docs/lab-safety.md`](docs/lab-safety.md) before beginning.

## What belongs here

- Shell scripts and reusable command files
- cloud-init and libvirt configuration templates
- Example output with credentials and host details removed
- Thumbnail source assets and diagrams
- Checksums and release notes
- Links to the companion article, video, and Inventive HQ utility

Large VM images, final video binaries, API keys, SSH private keys, passwords,
and environment files do not belong in this repository.

## License

Code and documentation are available under the [MIT License](LICENSE).

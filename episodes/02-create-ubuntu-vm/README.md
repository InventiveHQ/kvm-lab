# Episode 2: Create an Ubuntu VM

Create the first Ubuntu guest on the KVM host prepared in Episode 1. The guest
uses an Ubuntu 24.04 LTS cloud image, a qcow2 overlay, cloud-init, the QEMU guest
agent, private libvirt networking, SSH public-key authentication, and a serial
recovery console.

- Companion article: https://inventivehq.com/blog/create-ubuntu-vm-kvm-virt-install-cloud-init
- Virsh Command Builder: https://inventivehq.com/tools/developer/virsh-command-builder
- Release tag: `episode-02-v1`
- Next episode: `../03-manage-kvm-with-virsh/`

## Quick start

Use a lab host or an approved maintenance window. Complete Episode 1 first,
then run the creation script with the path to a public SSH key:

```bash
./create-vm.sh ~/.ssh/id_ed25519.pub
./validate-vm.sh
```

The script refuses to overwrite an existing domain, overlay, or seed image. It
starts `demo-ubuntu01` with 2 vCPUs and 2 GiB RAM and defines maximum values of
4 vCPUs and 4 GiB for Episode 3.

Review `COMMANDS.md` for the exact demonstrated command sequence and
`EXPECTED-OUTPUT.md` before treating any address or status as an error.

## Cleanup

Cleanup is deliberately separate and requires an explicit confirmation flag:

```bash
./cleanup-vm.sh --confirm
```

The Ubuntu base image is preserved because other qcow2 overlays may depend on
it. Inspect backing-file relationships before deleting any shared base image.

Create an Ubuntu VM with KVM, virt-install, and cloud-init

Episode 2 of the InventiveHQ KVM series creates the first Ubuntu guest on the host prepared in Episode 1. The finished VM has private networking, SSH public-key access, QEMU guest-agent visibility, a serial recovery console, and resource headroom for Episode 3.

COMPANION GUIDE
https://inventivehq.com/blog/create-ubuntu-vm-kvm-virt-install-cloud-init

FREE VIRSH COMMAND BUILDER
https://inventivehq.com/tools/developer/virsh-command-builder

DOWNLOADABLE LAB FILES
https://github.com/InventiveHQ/kvm-lab/tree/episode-02-v1/episodes/02-create-ubuntu-vm

PREVIOUS EPISODE — INSTALL KVM ON UBUNTU
https://inventivehq.com/blog/install-kvm-on-ubuntu

NEXT EPISODE — MANAGE THE VM WITH VIRSH
https://inventivehq.com/blog/virsh-commands-kvm-cheat-sheet

COMMANDS USED IN THIS VIDEO

Verify the host and install cloud-image tooling:
$ virsh --connect qemu:///system uri
$ virsh --connect qemu:///system net-info default
$ sudo apt update
$ sudo apt install -y cloud-image-utils
$ virsh --connect qemu:///system list --all

Set explicit guest paths:
$ VM=demo-ubuntu01
$ BASE=/var/lib/libvirt/images/ubuntu-24.04-server-cloudimg-amd64.img
$ DISK=/var/lib/libvirt/images/${VM}.qcow2
$ SEED=/var/lib/libvirt/images/${VM}-seed.iso

Download Ubuntu 24.04 LTS and create a 24 GiB overlay:
$ sudo wget -O "${BASE}.download" https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
$ sudo mv "${BASE}.download" "$BASE"
$ sudo qemu-img create -f qcow2 -F qcow2 -b "$BASE" "$DISK" 24G
$ sudo qemu-img info "$DISK"

Create the NoCloud seed from the downloadable user-data and meta-data files:
$ sudo cloud-localds "$SEED" demo-user-data.yaml demo-meta-data.yaml
$ sudo chown libvirt-qemu:kvm "$BASE" "$DISK" "$SEED"
$ sudo chmod 0640 "$BASE" "$DISK" "$SEED"

Create the VM with current and maximum resource values:
$ sudo virt-install --connect qemu:///system --name "$VM" --memory 2048,maxmemory=4096 --vcpus 2,maxvcpus=4 --cpu host-model --osinfo ubuntu24.04 --import --disk path="$DISK",format=qcow2,bus=virtio --disk path="$SEED",device=cdrom --network network=default,model=virtio --graphics none --console pty,target_type=serial --channel unix,target.type=virtio,target.name=org.qemu.guest_agent.0 --noautoconsole

Verify first boot, access, console, and resource headroom:
$ virsh --connect qemu:///system list --all
$ virsh --connect qemu:///system domifaddr "$VM" --source lease
$ ssh demo@GUEST_IP
$ cloud-init status --wait
$ systemctl is-active qemu-guest-agent
$ virsh --connect qemu:///system domifaddr "$VM" --source agent
$ virsh --connect qemu:///system ttyconsole "$VM"
$ virsh --connect qemu:///system console "$VM" --safe
$ virsh --connect qemu:///system vcpucount "$VM"
$ virsh --connect qemu:///system autostart "$VM"

The IP address is assigned by your libvirt DHCP network; query it rather than copying the lab address. Never place a private SSH key or production credential in cloud-init user-data.

CHAPTERS

00:00 What we are building
00:41 Preflight the KVM host
01:18 Prepare the guest disk
02:02 Configure cloud-init
02:49 Create the virtual machine
03:40 Verify cloud-init
04:19 Test console recovery
04:53 Validate resource headroom
05:36 Continue to Episode 3

Commands were validated in the InventiveHQ disposable nested-KVM lab on Ubuntu 26.04, libvirt 12.0.0, QEMU 10.2.1, and an Ubuntu 24.04 LTS guest.

#Linux #KVM #cloudinit #libvirt #Ubuntu

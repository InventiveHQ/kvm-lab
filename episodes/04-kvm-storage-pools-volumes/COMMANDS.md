KVM Storage Tutorial: Pools, Volumes & Live Disk Expansion

Episode 4 of the InventiveHQ KVM series creates a persistent libvirt storage pool, allocates and attaches a qcow2 volume, formats it inside Ubuntu, then expands the active disk and ext4 filesystem online without losing data.

COMPLETE KVM SERIES
https://inventivehq.com/blog/kvm-virtualization-series

COMPANION GUIDE
https://inventivehq.com/blog/kvm-storage-pools-volumes-expand-disks

FREE VIRSH COMMAND BUILDER
https://inventivehq.com/tools/developer/virsh-command-builder

VERSIONED LAB FILES
https://github.com/InventiveHQ/kvm-lab/tree/episode-04-v1/episodes/04-kvm-storage-pools-volumes

PREVIOUS EPISODE — MANAGE THE VM WITH VIRSH
https://inventivehq.com/blog/virsh-commands-kvm-cheat-sheet

NEXT EPISODE — CUSTOM KVM NETWORKING
https://inventivehq.com/blog/kvm-networking-custom-nat-static-dhcp

COMMANDS USED IN THIS VIDEO

Inventory the system connection, pools, and guest disks:
$ export LIBVIRT_DEFAULT_URI=qemu:///system
$ VM=demo-ubuntu01
$ virsh uri
$ virsh pool-list --all
$ virsh domblklist "$VM" --details
$ virsh pool-info tutorial-data
$ sudo test ! -e /var/lib/libvirt/tutorial-data/demo-data01.qcow2

Create and persist the directory pool:
$ sudo mkdir -p /var/lib/libvirt/tutorial-data
$ virsh pool-define-as tutorial-data dir --target /var/lib/libvirt/tutorial-data
$ virsh pool-build tutorial-data
$ virsh pool-start tutorial-data
$ virsh pool-autostart tutorial-data
$ virsh pool-info tutorial-data

Create and inspect the sparse qcow2 volume:
$ virsh vol-create-as tutorial-data demo-data01.qcow2 5GiB --format qcow2
$ virsh vol-info --pool tutorial-data demo-data01.qcow2
$ virsh vol-path --pool tutorial-data demo-data01.qcow2

Attach the volume live and persistently:
$ DATA_DISK=$(virsh vol-path --pool tutorial-data demo-data01.qcow2)
$ virsh attach-disk "$VM" "$DATA_DISK" vdb --targetbus virtio --subdriver qcow2 --live --config
$ virsh domblklist "$VM" --details
$ virsh domblkinfo "$VM" vdb
$ virsh dumpxml "$VM" --inactive > "${VM}-with-data-disk.xml"

Inside Ubuntu, verify and format only the new empty device:
$ lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS
$ sudo blkid /dev/vdb || true
$ sudo mkfs.ext4 -L demo-data /dev/vdb
$ sudo mkdir -p /srv/demo-data
$ sudo mount /dev/vdb /srv/demo-data
$ echo "InventiveHQ KVM storage lab" | sudo tee /srv/demo-data/README.txt
$ df -hT /srv/demo-data
$ sudo cat /srv/demo-data/README.txt

The attached active qcow2 image rejected vol-resize because QEMU held its write lock:
$ virsh vol-resize --pool tutorial-data demo-data01.qcow2 8GiB

Resize the active domain device correctly:
$ virsh blockresize "$VM" vdb 8GiB
$ virsh domblkinfo "$VM" vdb
$ virsh vol-info --pool tutorial-data demo-data01.qcow2

Inside Ubuntu, expand ext4 online and verify the data:
$ lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS /dev/vdb
$ sudo resize2fs /dev/vdb
$ df -hT /srv/demo-data
$ sudo cat /srv/demo-data/README.txt

Documented safe detach sequence — do not run while the filesystem is mounted:
$ sudo sync
$ sudo umount /srv/demo-data
$ virsh detach-disk demo-ubuntu01 vdb --live --config

This episode covers expansion only. Shrinking filesystems, partitions, and qcow2 images has different constraints and can destroy data. Query your own targets and paths instead of copying the lab values blindly.

CHAPTERS

00:00 What we are building
00:39 Storage preflight
01:12 Create the storage pool
01:48 Create and attach the volume
02:24 Format and mount inside Ubuntu
03:04 Expand the active virtual disk
03:41 Expand the guest filesystem
04:20 Verify and detach safely
04:57 Continue to Episode 5

Validated in the InventiveHQ nested-KVM lab on Ubuntu 26.04 LTS, libvirt 12.0.0, QEMU 10.2.1, and an Ubuntu 24.04 LTS guest.

#Linux #KVM #libvirt #qcow2 #Ubuntu

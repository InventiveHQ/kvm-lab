# Episode 15 commands

```bash
sudo mkdir -p /var/lib/libvirt/format-lab
virsh pool-define-as format-lab dir --target /var/lib/libvirt/format-lab
virsh pool-start format-lab
virsh pool-autostart format-lab

virsh vol-create-as format-lab ep15-source.qcow2 1G --format qcow2
sudo qemu-io -f qcow2 -c 'write -P 0x5a 0 16M' \
  /var/lib/libvirt/format-lab/ep15-source.qcow2

sudo qemu-img convert -p -f qcow2 -O raw \
  /var/lib/libvirt/format-lab/ep15-source.qcow2 \
  /var/lib/libvirt/format-lab/ep15-converted.raw
sudo qemu-img compare -f qcow2 -F raw \
  /var/lib/libvirt/format-lab/ep15-source.qcow2 \
  /var/lib/libvirt/format-lab/ep15-converted.raw

virsh pool-refresh format-lab
virsh vol-list format-lab --details
qemu-img info /var/lib/libvirt/format-lab/ep15-source.qcow2
qemu-img info /var/lib/libvirt/format-lab/ep15-converted.raw
```

The observed 4 KiB write microbenchmark was effectively tied and is not a
general performance conclusion. Benchmark the actual storage stack and guest
workload before selecting a production format.


# Episode 7 commands

```bash
virsh domuuid demo-ubuntu01
virsh domiflist demo-ubuntu01
virsh domblklist demo-ubuntu01 --details
virsh shutdown demo-ubuntu01

virt-clone --original demo-ubuntu01 --name demo-clone01 \
  --file /var/lib/libvirt/images/demo-clone01.qcow2 \
  --file /var/lib/libvirt/tutorial-data/demo-clone-data01.qcow2 \
  --check disk_size=off --print-xml

virt-clone --original demo-ubuntu01 --name demo-clone01 \
  --file /var/lib/libvirt/images/demo-clone01.qcow2 \
  --file /var/lib/libvirt/tutorial-data/demo-clone-data01.qcow2 \
  --check disk_size=off
virsh detach-disk demo-clone01 sda --config

virt-sysprep -d demo-clone01 \
  --enable machine-id,ssh-hostkeys,dhcp-client-state,net-hostname,udev-persistent-net,customize \
  --hostname demo-clone01 \
  --run-command 'cloud-init clean --logs'
```

If Netplan matches the source MAC, replace it with the clone's reviewed MAC
before first boot. Verify UUIDs, MACs, hostnames, machine IDs, host-key
fingerprints, addresses, and disk paths side by side.

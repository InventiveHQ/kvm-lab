# Commands shown in Episode 18

```bash
./preflight.sh ep18-migrate01 qemu+ssh://sean@destination/system
sudo virsh shutdown ep18-migrate01
sudo virsh dumpxml ep18-migrate01 > ep18-migrate01.xml
sudo qemu-img info --backing-chain /var/lib/libvirt/images/ep18-migrate01.qcow2
sha256sum /var/lib/libvirt/images/ep18-migrate01.qcow2
# Transfer the XML, every writable disk, and required read-only backing files.
# Define on exactly one host, start, then validate identity and application data.
```

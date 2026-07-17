# Episode 6 commands

```bash
virsh domblklist demo-ubuntu01 --details
virsh qemu-agent-command demo-ubuntu01 '{"execute":"guest-ping"}'

virsh snapshot-create-as demo-ubuntu01 \
  --name ep06-backup --disk-only --quiesce --atomic \
  --diskspec vda,snapshot=external,file=/var/lib/libvirt/images/demo-ubuntu01-ep06-overlay.qcow2,driver=qcow2 \
  --diskspec vdb,snapshot=external,file=/var/lib/libvirt/tutorial-data/demo-data01-ep06-overlay.qcow2,driver=qcow2 \
  --diskspec sda,snapshot=no

qemu-img convert --force-share -p -O qcow2 \
  /var/lib/libvirt/images/demo-ubuntu01.qcow2 \
  /var/lib/libvirt/backups/ep06/demo-ubuntu01-system.qcow2
qemu-img convert --force-share -p -O qcow2 \
  /var/lib/libvirt/tutorial-data/demo-data01.qcow2 \
  /var/lib/libvirt/backups/ep06/demo-ubuntu01-data.qcow2

virsh blockcommit demo-ubuntu01 vda \
  --base /var/lib/libvirt/images/demo-ubuntu01.qcow2 \
  --active --pivot --delete --wait --verbose
virsh blockcommit demo-ubuntu01 vdb \
  --base /var/lib/libvirt/tutorial-data/demo-data01.qcow2 \
  --active --pivot --delete --wait --verbose
virsh snapshot-delete demo-ubuntu01 ep06-backup --metadata
```

Create disposable overlays backed by the backup files and import them with
`--network none`. Never boot the backup files directly and never connect a
restored clone to production networks until its identity is changed.

# Episode 12 commands

```bash
sudo apt-get install libguestfs-tools

# The source must be shut off for a consistent clone.
sudo virt-clone \
  --original demo-ubuntu01 \
  --name ep12-rescue01 \
  --file /var/lib/libvirt/images/ep12-rescue01.qcow2 \
  --file /var/lib/libvirt/tutorial-data/ep12-rescue-data01.qcow2 \
  --check disk_size=off

# Reproduce a reversible boot-target failure while the clone is shut off.
sudo virt-customize -d ep12-rescue01 \
  --run-command 'ln -sfn /usr/lib/systemd/system/emergency.target /etc/systemd/system/default.target'

virsh start ep12-rescue01
virsh domstate ep12-rescue01
virsh qemu-agent-command ep12-rescue01 '{"execute":"guest-ping"}'

# The disposable guest cannot shut down through normal guest services.
virsh destroy ep12-rescue01

# Repair the copied disk offline.
sudo virt-customize -d ep12-rescue01 \
  --run-command 'ln -sfn /usr/lib/systemd/system/multi-user.target /etc/systemd/system/default.target'

virsh start ep12-rescue01
virsh domstate ep12-rescue01
virsh qemu-agent-command ep12-rescue01 '{"execute":"guest-ping"}'
```

Never run libguestfs write operations against a disk owned by a running VM.
Use a backup or disposable overlay before repairing irreplaceable storage.


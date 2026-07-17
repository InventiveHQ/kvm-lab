# Episode 10 commands

```bash
virsh -c qemu+ssh://sean@192.168.124.12/system version
virsh -c qemu+ssh://sean@192.168.124.12/system net-list --all
virsh -c qemu+ssh://sean@192.168.124.12/system pool-list --all
virsh dumpxml demo-ubuntu01 --inactive > demo-ubuntu01-before-migration.xml

virsh change-media demo-ubuntu01 sda --eject --live --config

virsh migrate --live --persistent --undefinesource \
  --copy-storage-all --verbose --compressed --auto-converge \
  demo-ubuntu01 qemu+ssh://sean@192.168.124.12/system

# Verify the source no longer defines the domain and the destination does.
virsh list --all
virsh -c qemu+ssh://sean@192.168.124.12/system dominfo demo-ubuntu01
virsh -c qemu+ssh://sean@192.168.124.12/system domblklist demo-ubuntu01 --details
virsh -c qemu+ssh://sean@192.168.124.12/system domifaddr demo-ubuntu01 --source agent
```

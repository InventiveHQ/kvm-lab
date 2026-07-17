# Episode 11 commands

```bash
# Read-only diagnosis: begin with state and the complete disk map.
virsh domstate ep11-broken01
virsh dominfo ep11-broken01
virsh domblklist ep11-broken01 --details
virsh dumpxml --inactive ep11-broken01

# Reproduce the start attempt and preserve the complete error.
virsh start ep11-broken01

# Correlate the error with libvirt service logs.
sudo journalctl -u libvirtd -u virtqemud --since '-5 minutes' --no-pager

# Check the exact path named by the first causal error.
sudo -u libvirt-qemu test -r /var/lib/libvirt/images/ep11-does-not-exist.qcow2

# Repair only the incorrect inactive disk source.
virsh dumpxml --inactive ep11-broken01 |
  sed 's#/var/lib/libvirt/images/ep11-does-not-exist.qcow2#/var/lib/libvirt/images/ep11-broken01.qcow2#' |
  sudo virsh define /dev/stdin

# Start and prove the repaired guest is responsive.
virsh start ep11-broken01
virsh domstate ep11-broken01
virsh domblklist ep11-broken01 --details
virsh qemu-agent-command ep11-broken01 '{"execute":"guest-ping"}'
```

Do not replace XML blindly from a stale backup. Compare the failing definition
with the last known-good definition and preserve intentional later changes.


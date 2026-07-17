# Expected output

Exact IDs, addresses, image sizes, and timestamps vary by host.

- `virsh list --all` shows `demo-ubuntu01` in the `running` state.
- `virsh domifaddr demo-ubuntu01 --source lease` reports a private address from
  the `default` libvirt network, commonly in `192.168.122.0/24`.
- Guest `cloud-init status --wait` finishes with `status: done`.
- Guest `systemctl is-active qemu-guest-agent` prints `active`.
- `virsh ttyconsole demo-ubuntu01` prints a PTY such as `/dev/pts/0`.
- `virsh vcpucount demo-ubuntu01` shows 2 current and 4 maximum vCPUs.
- The inactive XML shows 2 GiB current / 4 GiB maximum memory and 2 current /
  4 maximum vCPUs.

If the guest address is initially absent, wait for first boot and query the
DHCP lease again. Agent-sourced addresses appear only after cloud-init installs
and starts `qemu-guest-agent`.

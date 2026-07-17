# Expected output

- The baseline shows `demo-ubuntu01` running with 2 current vCPUs, 4 maximum
  vCPUs, 2 GiB current memory, and 4 GiB maximum memory.
- After `apply-resource-change.sh`, libvirt reports 4 current vCPUs and 4 GiB
  current memory in both the live guest and persistent configuration.
- Ubuntu may initially show CPUs 2 and 3 as present but offline. After onlining
  them deliberately, `nproc` reports 4.
- `virsh domifaddr --source lease` uses the libvirt DHCP lease. `--source agent`
  requires a running QEMU guest agent and a writable connection.
- `virsh ttyconsole demo-ubuntu01` reports the serial PTY. Disconnect from
  `virsh console demo-ubuntu01 --safe` with `Ctrl+]`.

Do not copy lab IP addresses. Query the current lease or guest agent on your
host.

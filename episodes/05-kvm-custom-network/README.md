# Episode 5: Custom KVM NAT network with static DHCP

Create a persistent libvirt NAT network, reserve a predictable address, attach
a second virtio NIC to `demo-ubuntu01`, and preserve the original default route
with a higher metric on the secondary interface.

- Series index: https://inventivehq.com/blog/kvm-virtualization-series
- Companion article: https://inventivehq.com/blog/kvm-networking-custom-nat-static-dhcp
- Virsh Command Builder: https://inventivehq.com/tools/developer/virsh-command-builder
- Release tag: `episode-05-v1`
- Previous episode: `../04-kvm-storage-pools-volumes/`

## Workflow

Review `tutorial-net.xml` for subnet, bridge, and MAC conflicts, then run:

```bash
./create-network.sh
./attach-network.sh
```

The host will show the NIC before Ubuntu has an address. Match the interface by
MAC, install `60-tutorial-net.yaml` with the correct guest interface name, run
`netplan generate`, and keep serial-console recovery available while applying
the network change.

```bash
./validate-network.sh
```

See `COMMANDS.md` for the full host and guest verification sequence.

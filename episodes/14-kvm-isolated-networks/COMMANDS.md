# Episode 14 commands

```bash
virsh net-define app-net.xml
virsh net-start app-net
virsh net-autostart app-net
virsh net-define db-net.xml
virsh net-start db-net
virsh net-autostart db-net
virsh net-list --all

virsh attach-interface demo-ubuntu01 --type network --source app-net \
  --model virtio --mac 52:54:00:77:14:01 --live
virsh attach-interface demo-ubuntu01 --type network --source db-net \
  --model virtio --mac 52:54:00:77:14:02 --live

# The validated guest used temporary addresses for a live-only proof.
ip addr add 192.168.160.10/24 dev enp9s0
ip addr add 192.168.170.10/24 dev enp10s0
ping -c 2 192.168.160.1
ping -I 192.168.170.10 -c 2 1.1.1.1
```

The first ping must succeed and the WAN-bound database-source ping must fail.
Do not add a default route to an isolated segment merely to make a test pass.


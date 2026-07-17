# Episode 13 commands

```bash
ip -brief address show br0
ip route show default
virsh domiflist ihq-kvm-ep02

virsh attach-interface ihq-kvm-ep02 \
  --type bridge \
  --source br0 \
  --model virtio \
  --mac 52:54:00:71:13:01 \
  --live

# Inside the guest, discover the new interface and address.
ip -brief address
ip route get 192.168.1.1
ping -c 3 192.168.1.1

# Prove the LAN can reach the guest before making anything persistent.
ping -c 3 192.168.1.196

virsh detach-interface ihq-kvm-ep02 \
  --type bridge \
  --mac 52:54:00:71:13:01 \
  --live
```


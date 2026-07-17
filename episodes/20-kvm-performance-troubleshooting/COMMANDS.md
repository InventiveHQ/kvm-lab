# Commands shown in Episode 20

```bash
virsh domstats ep18-migrate01 --vcpu --balloon
virsh vcpuinfo ep18-migrate01
virsh domblkstat ep18-migrate01 vda --human
virsh domifstat ep18-migrate01 vnet0
./run-bounded-loads.sh ep18-migrate01 192.168.122.81 /path/to/private-key
```

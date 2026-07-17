# Address and identity plan

| Node | Address | MAC | Votes | Capacity |
| --- | --- | --- | ---: | --- |
| kvm-ha01 | 192.168.124.21 | 52:54:00:71:22:01 | 1 | 2 vCPU, 4 GiB |
| kvm-ha02 | 192.168.124.22 | 52:54:00:71:22:02 | 1 | 2 vCPU, 4 GiB |
| kvm-ha03 | 192.168.124.23 | 52:54:00:71:22:03 | 1 | 2 vCPU, 4 GiB |

All three nodes must agree on these names through `/etc/hosts` and use the
outer lab gateway for time and package access. Two votes constitute quorum.
The cluster is sized so one node can fail while a surviving node still has room
for the single demonstration guest.

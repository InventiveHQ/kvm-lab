# Three-node KVM HA lab topology

```text
                         outer hypervisor: dell01
                    fencing authority and lab failure injector
                                      |
                         ihq-kvm-lab 192.168.124.0/24
                     /                |                 \
        kvm-ha01 .21             kvm-ha02 .22       kvm-ha03 .23
        one vote                  one vote            one vote
        nested KVM                nested KVM          nested KVM
                     \                |                 /
                      single shared lab storage (first pass)
```

The first HA pass deliberately uses one shared-storage service so the compute
failover behavior can be isolated. That service is a documented single point
of failure and is replaced during Episode 26. This topology is a teaching lab,
not a production reference architecture.

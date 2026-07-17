# Episode 16: Build repeatable KVM VMs with cloud-init

Create independent qcow2 overlays and NoCloud seeds from parameterized public
templates. Each guest receives a unique name, instance ID, MAC, address,
machine ID, SSH host keys, libvirt UUID, and writable disk.

- Release tag: `episode-16-v1`
- Series index: https://inventivehq.com/blog/kvm-virtualization-series

The public templates contain no real key. Pass a reviewed public-key file to
the script; never place a private key, password, or token in cloud-init data.


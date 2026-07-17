KVM Networking Tutorial: Custom NAT & Static DHCP

Episode 5 of the InventiveHQ KVM series creates a persistent custom NAT network, reserves a predictable DHCP address, hot-plugs a second virtio NIC, configures it with Netplan, and preserves the original default route with explicit metrics.

COMPLETE KVM SERIES AND FUTURE ROADMAP
https://inventivehq.com/blog/kvm-virtualization-series

COMPANION GUIDE
https://inventivehq.com/blog/kvm-networking-custom-nat-static-dhcp

FREE VIRSH COMMAND BUILDER
https://inventivehq.com/tools/developer/virsh-command-builder

VERSIONED LAB FILES
https://github.com/InventiveHQ/kvm-lab/tree/episode-05-v1/episodes/05-kvm-custom-network

PREVIOUS EPISODE — KVM STORAGE
https://inventivehq.com/blog/kvm-storage-pools-volumes-expand-disks

COMMANDS USED IN THIS VIDEO

Inventory libvirt networks, guest interfaces, host addresses, and routes:
$ export LIBVIRT_DEFAULT_URI=qemu:///system
$ VM=demo-ubuntu01
$ virsh uri
$ virsh net-list --all
$ virsh domiflist "$VM"
$ ip -brief address
$ ip route
$ virsh net-info tutorial-net
$ virsh dumpxml "$VM" | grep -i '52:54:00:77:05:01'

Create tutorial-net.xml:
<network>
  <name>tutorial-net</name>
  <forward mode='nat'/>
  <bridge name='virbr150' stp='on' delay='0'/>
  <domain name='tutorial.test'/>
  <ip address='192.168.150.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.150.100' end='192.168.150.200'/>
      <host mac='52:54:00:77:05:01' name='demo-ubuntu01-data' ip='192.168.150.10'/>
    </dhcp>
  </ip>
</network>

Define, start, and persist the custom network:
$ virsh net-define tutorial-net.xml
$ virsh net-start tutorial-net
$ virsh net-autostart tutorial-net
$ virsh net-info tutorial-net
$ virsh net-dumpxml tutorial-net
$ ip -brief address show virbr150

Attach the second NIC live and persistently:
$ virsh attach-interface "$VM" network tutorial-net --model virtio --mac 52:54:00:77:05:01 --live --config
$ virsh domiflist "$VM"
$ virsh net-dhcp-leases tutorial-net
$ virsh domifaddr "$VM" --source agent

Inside Ubuntu, map interface names to MAC addresses:
$ ip -brief link
$ ip -brief address
$ for nic in /sys/class/net/*; do printf '%s ' "$(basename "$nic")"; cat "$nic/address"; done

Create /etc/netplan/60-tutorial-net.yaml using the interface discovered in your guest:
network:
  version: 2
  ethernets:
    enp8s0:
      dhcp4: true
      dhcp4-overrides:
        route-metric: 200

Validate and apply Netplan while serial-console recovery remains available:
$ sudo chmod 600 /etc/netplan/60-tutorial-net.yaml
$ sudo netplan generate
$ sudo netplan apply

Verify the fixed address and route selection inside Ubuntu:
$ ip -brief address show enp8s0
$ ip route show default
$ ip route get 1.1.1.1
$ ping -c 2 -I 192.168.150.10 192.168.150.1

Correlate the result from the KVM host:
$ virsh net-dhcp-leases tutorial-net
$ virsh domifaddr "$VM" --source agent
$ virsh domiflist "$VM"
$ virsh dumpxml "$VM" --inactive > "${VM}-two-networks.xml"

Documented cleanup — inventory dependent domains before removing the network:
$ sudo rm /etc/netplan/60-tutorial-net.yaml
$ sudo netplan apply
$ virsh detach-interface demo-ubuntu01 network --mac 52:54:00:77:05:01 --live --config
$ virsh net-destroy tutorial-net
$ virsh net-undefine tutorial-net

The interface name, subnet, address, and bridge are lab examples. Match interfaces by MAC and choose a non-overlapping subnet in your own environment.

CHAPTERS

00:00 What we are building
00:39 Network preflight
01:08 Write the network definition
01:43 Activate the network
02:14 Attach the second interface
02:49 Configure the guest interface
03:25 Verify guest routing
04:03 Verify from libvirt
04:42 Recap and series roadmap

Validated in the InventiveHQ nested-KVM lab on Ubuntu 26.04 LTS, libvirt 12.0.0, QEMU 10.2.1, and an Ubuntu 24.04 LTS guest.

#Linux #KVM #libvirt #Netplan #Virtualization

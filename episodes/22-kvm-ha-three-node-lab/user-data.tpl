#cloud-config
hostname: __HOSTNAME__
manage_etc_hosts: false
users:
  - name: ihq
    groups: [adm, sudo, libvirt]
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - __SSH_PUBLIC_KEY__
ssh_pwauth: false
disable_root: true
package_update: true
packages:
  - qemu-system-x86
  - libvirt-daemon-system
  - libvirt-clients
  - virtinst
  - pacemaker
  - corosync
  - pcs
  - resource-agents-base
  - resource-agents-extra
  - fence-agents-base
  - fence-agents-virsh
  - qemu-guest-agent
write_files:
  - path: /etc/hosts
    permissions: '0644'
    content: |
      127.0.0.1 localhost
      127.0.1.1 __HOSTNAME__
      192.168.124.21 kvm-ha01
      192.168.124.22 kvm-ha02
      192.168.124.23 kvm-ha03
runcmd:
  - [systemctl, enable, --now, libvirtd]
  - [systemctl, enable, --now, qemu-guest-agent]
  - [systemctl, enable, --now, pcsd]

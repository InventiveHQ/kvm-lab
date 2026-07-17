#cloud-config
hostname: __HOSTNAME__
manage_etc_hosts: true
users:
  - name: ihq
    groups: [adm, sudo]
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - __SSH_PUBLIC_KEY__
ssh_pwauth: false
disable_root: true
package_update: true
packages:
  - qemu-guest-agent
runcmd:
  - [systemctl, enable, --now, qemu-guest-agent]
  - [sh, -c, "printf 'provisioned-by=episode-16\n' > /etc/ihq-template-release"]


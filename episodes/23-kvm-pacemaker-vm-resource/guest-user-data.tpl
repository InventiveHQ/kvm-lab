#cloud-config
hostname: ha-demo01
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
write_files:
  - path: /var/lib/ha-demo-proof
    permissions: '0644'
    content: |
      cluster-owned-by=pacemaker
  - path: /etc/systemd/system/ha-demo-http.service
    permissions: '0644'
    content: |
      [Unit]
      Description=HA demonstration HTTP service
      After=network-online.target
      Wants=network-online.target

      [Service]
      ExecStart=/usr/bin/python3 -m http.server 8080 --directory /var/lib
      Restart=always

      [Install]
      WantedBy=multi-user.target
runcmd:
  - [systemctl, daemon-reload]
  - [systemctl, enable, --now, ha-demo-http.service]

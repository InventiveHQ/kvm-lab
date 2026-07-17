version: 2
ethernets:
  primary:
    match:
      macaddress: "__MAC__"
    set-name: enp1s0
    addresses:
      - __ADDRESS__/24
    routes:
      - to: default
        via: 192.168.122.1
    nameservers:
      addresses: [192.168.122.1]


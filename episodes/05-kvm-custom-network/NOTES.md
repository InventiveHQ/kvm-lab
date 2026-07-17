# Validation and safety notes

- Validated July 16, 2026 with libvirt 12.0.0, QEMU 10.2.1, Ubuntu 26.04 LTS
  on the host, and Ubuntu 24.04 LTS in the guest.
- Check the proposed subnet and bridge against host, VPN, container, and
  physical-network routes before defining the network.
- Hot-plugging the NIC does not configure it inside the guest.
- Keep serial-console recovery available while applying Netplan remotely.
- Omit the `<forward>` element for an intentionally isolated network.
- Inventory every dependent domain before destroying or undefining a network.

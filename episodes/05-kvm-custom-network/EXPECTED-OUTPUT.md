# Expected output

- `tutorial-net` reports active, persistent, autostarting, and bridge `virbr150`.
- The guest shows a second virtio interface with MAC `52:54:00:77:05:01` before
  it has an address.
- After Netplan applies, the fixed lease maps that MAC to `192.168.150.10/24`.
- The original default route remains metric 100; the secondary route uses 200.
- `ip route get 1.1.1.1` selects the original interface.
- A source-bound ping from `192.168.150.10` reaches gateway `192.168.150.1`.

Guest interface names and lease-expiration timestamps vary. Match by MAC.

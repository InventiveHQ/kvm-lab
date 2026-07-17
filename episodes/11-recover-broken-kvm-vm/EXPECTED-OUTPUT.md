# Expected output

The intentionally broken definition fails before QEMU starts:

```text
error: Failed to start domain 'ep11-broken01'
error: Cannot access storage file '/var/lib/libvirt/images/ep11-does-not-exist.qcow2' (as uid:64055, gid:991): No such file or directory
```

The service log repeats the same causal path. After the narrow XML repair:

```text
Domain 'ep11-broken01' started
running
{"return":{}}
```

The numeric QEMU user and group IDs vary by distribution. The important facts
are the missing path, the domain remaining shut off, and a successful agent
ping after repair.


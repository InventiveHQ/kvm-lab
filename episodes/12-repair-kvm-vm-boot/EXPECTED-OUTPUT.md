# Expected output

With `default.target` linked to `emergency.target`, the domain can remain
`running` while normal readiness fails:

```text
running
error: Guest agent is not responding: QEMU guest agent is not connected
```

After the offline repair to `multi-user.target`:

```text
Domain 'ep12-rescue01' started
running
{"return":{}}
```

The agent error is evidence that normal guest services are unavailable; it is
not by itself a diagnosis. Console output, the boot configuration, filesystem
checks, and previous changes determine the repair.


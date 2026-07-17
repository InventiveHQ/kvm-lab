# Episode 25: Test host failure and automatic VM recovery

Start the external probe, abruptly stop the active outer domain, and record
detection, successful fencing, guest restart, and first application success as
separate timestamps. Verify data before rejoining the failed host.

- Release tag: `episode-25-v1`
- Series index: https://inventivehq.com/blog/kvm-virtualization-series

This is a destructive failure test against the disposable nested lab only.

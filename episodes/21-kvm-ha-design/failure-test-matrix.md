# Failure and recovery test matrix

| Failure | Safe authority | Expected result | Evidence |
| --- | --- | --- | --- |
| One compute node stops | Outer-hypervisor fencing | Two votes retain quorum; guest restarts once | fence history, resource history, probe log |
| Active node loses cluster traffic | Outer-hypervisor fencing | Isolated owner is powered off before restart | power state precedes new guest start |
| Two nodes stop | Quorum policy | Remaining node refuses unsafe recovery | quorum and resource status |
| Shared-storage service stops | None in first design | Recovery is blocked; documented SPOF | mount and resource failure |
| One redundant-storage path stops | Surviving path in Episode 26 | Guest stays available, data remains valid | path state, checksum, probe log |

Recovery target for the nested lab is measured rather than promised: record
detection, fencing, restart, and application recovery separately during every
test.

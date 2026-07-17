# Episode 9 commands

```bash
lscpu | grep -E '^CPU\(s\):|On-line|Thread|Core|Socket|NUMA'
grep -E 'HugePages_Total|HugePages_Free|Hugepagesize' /proc/meminfo
virsh vcpupin demo-ubuntu01
virsh emulatorpin demo-ubuntu01
virsh domstats demo-ubuntu01 --vcpu --balloon --block
virsh blkdeviotune demo-ubuntu01 vdb --live

# Inside the guest; use a bounded file, never a raw production device.
fio --name=baseline --filename=/srv/demo-data/ep09-fio.bin --size=512M \
  --rw=write --bs=1M --direct=1 --ioengine=libaio --iodepth=16 \
  --runtime=12 --time_based --group_reporting --output-format=json

virsh blkdeviotune demo-ubuntu01 vdb \
  --read-bytes-sec 20M --write-bytes-sec 20M --live

virsh blkdeviotune demo-ubuntu01 vdb \
  --read-bytes-sec 0 --write-bytes-sec 0 --live
```

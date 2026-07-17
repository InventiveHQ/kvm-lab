#!/usr/bin/env bash
set -euo pipefail

domain=${DOMAIN:-demo-ubuntu01}
disk=${DISK:-vdb}

echo '== Host topology =='
lscpu | grep -E '^CPU\(s\):|On-line|Thread|Core|Socket|NUMA'

echo '== Huge pages =='
grep -E 'HugePages_Total|HugePages_Free|Hugepagesize' /proc/meminfo

echo '== Domain affinity =='
sudo virsh vcpupin "$domain"
sudo virsh emulatorpin "$domain"

echo '== Current disk limits =='
sudo virsh blkdeviotune "$domain" "$disk" --live

echo '== Live counters =='
sudo virsh domstats "$domain" --vcpu --balloon --block

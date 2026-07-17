#!/usr/bin/env bash
set -euo pipefail

export LIBVIRT_DEFAULT_URI=${LIBVIRT_DEFAULT_URI:-qemu:///system}
VM=${1:-demo-ubuntu01}

virsh pool-info tutorial-data
virsh vol-info --pool tutorial-data demo-data01.qcow2
virsh domblklist "$VM" --details
virsh domblkinfo "$VM" vdb
virsh dumpxml "$VM" --inactive | grep -A8 -B2 'demo-data01.qcow2'

echo "Guest verification: findmnt /srv/demo-data; df -hT /srv/demo-data; sudo cat /srv/demo-data/README.txt"

#!/usr/bin/env bash
set -euo pipefail

export LIBVIRT_DEFAULT_URI=${LIBVIRT_DEFAULT_URI:-qemu:///system}
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

if virsh net-info tutorial-net >/dev/null 2>&1; then
  echo "tutorial-net already exists; inspect it before continuing." >&2
  exit 1
fi
if ip link show virbr150 >/dev/null 2>&1; then
  echo "virbr150 already exists; choose another bridge name." >&2
  exit 1
fi

virsh net-define "$SCRIPT_DIR/tutorial-net.xml"
virsh net-start tutorial-net
virsh net-autostart tutorial-net
virsh net-info tutorial-net
virsh net-dumpxml tutorial-net

#!/usr/bin/env bash
set -uo pipefail

errors=0
uri=qemu:///system
target_user=${1:-${SUDO_USER:-${USER:-}}}

pass() {
  printf 'PASS: %s\n' "$1"
}

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  errors=$((errors + 1))
}

if command -v kvm-ok >/dev/null 2>&1 && kvm-ok >/dev/null 2>&1; then
  pass 'KVM acceleration is available.'
else
  fail 'kvm-ok did not confirm KVM acceleration.'
fi

if [[ -c /dev/kvm ]]; then
  pass '/dev/kvm is a character device.'
else
  fail '/dev/kvm is not available.'
fi

if systemctl is-active --quiet libvirtd; then
  pass 'libvirtd is active.'
else
  fail 'libvirtd is not active.'
fi

if [[ -n ${target_user} ]] && getent passwd "${target_user}" >/dev/null; then
  for group in libvirt kvm; do
    if id -nG "${target_user}" | tr ' ' '\n' | grep -Fxq "${group}"; then
      pass "${target_user} belongs to ${group}."
    else
      fail "${target_user} does not belong to ${group}."
    fi
  done
else
  fail 'Could not determine the non-root account to verify.'
fi

if actual_uri=$(virsh --connect "${uri}" uri 2>/dev/null); then
  if [[ ${actual_uri} == "${uri}" ]]; then
    pass "virsh connected to ${uri}."
  else
    fail "virsh returned the unexpected URI: ${actual_uri}"
  fi
else
  fail "The current login session cannot connect to ${uri}. Sign out and back in after changing groups."
fi

if network_info=$(virsh --connect "${uri}" net-info default 2>/dev/null); then
  if grep -Eq '^Active:[[:space:]]+yes$' <<<"${network_info}"; then
    pass 'The default network is active.'
  else
    fail 'The default network exists but is inactive.'
  fi
  if grep -Eq '^Autostart:[[:space:]]+yes$' <<<"${network_info}"; then
    pass 'The default network is set to autostart.'
  else
    fail 'The default network is not set to autostart.'
  fi
else
  fail 'The default libvirt network was not found.'
fi

printf '\nVersion information:\n'
virsh --connect "${uri}" version 2>/dev/null || true

printf '\nDefined guests (an empty list is expected on a new host):\n'
virsh --connect "${uri}" list --all 2>/dev/null || true

printf '\nvirt-host-validate report (warnings require review but are not counted automatically):\n'
if command -v virt-host-validate >/dev/null 2>&1; then
  if [[ ${EUID} -eq 0 ]]; then
    virt-host-validate qemu || true
  else
    printf 'Run "sudo virt-host-validate qemu" separately for the complete privileged report.\n'
    virt-host-validate qemu || true
  fi
else
  fail 'virt-host-validate is missing.'
fi

if ((errors > 0)); then
  printf '\nVerification failed with %d blocking check(s).\n' "$errors" >&2
  exit 1
fi

printf '\nKVM host verification passed.\n'

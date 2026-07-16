#!/usr/bin/env bash
set -Eeuo pipefail

errors=0

pass() {
  printf 'PASS: %s\n' "$1"
}

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  errors=$((errors + 1))
}

printf 'KVM host preflight\n'
printf 'Kernel: %s\n' "$(uname -r)"
printf 'Architecture: %s\n' "$(uname -m)"

if grep -Eq '(^|[[:space:]])(vmx|svm)([[:space:]]|$)' /proc/cpuinfo; then
  pass 'The CPU exposes Intel VT-x (vmx) or AMD-V (svm).'
else
  fail 'No vmx or svm CPU flag was found. Enable virtualization in firmware or expose nested virtualization.'
fi

if [[ -e /dev/kvm ]]; then
  pass '/dev/kvm exists.'
  ls -l /dev/kvm
else
  fail '/dev/kvm does not exist.'
fi

if [[ -r /dev/kvm && -w /dev/kvm ]]; then
  pass 'The current account can read and write /dev/kvm.'
else
  printf 'INFO: The current account cannot yet read and write /dev/kvm. The install step adds it to the kvm group.\n'
fi

if command -v kvm-ok >/dev/null 2>&1; then
  printf '\nkvm-ok output:\n'
  if kvm-ok; then
    pass 'kvm-ok reports that acceleration can be used.'
  else
    fail 'kvm-ok could not confirm usable KVM acceleration.'
  fi
else
  printf 'INFO: kvm-ok is not installed yet; it is supplied by the cpu-checker package.\n'
fi

if ((errors > 0)); then
  printf '\nPreflight failed with %d blocking check(s).\n' "$errors" >&2
  exit 1
fi

printf '\nPreflight passed.\n'

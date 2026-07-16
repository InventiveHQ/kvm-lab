#!/usr/bin/env bash
set -Eeuo pipefail

if [[ ${EUID} -ne 0 ]]; then
  printf 'Run this script with sudo: sudo %s [username]\n' "$0" >&2
  exit 1
fi

if [[ ! -r /etc/os-release ]]; then
  printf 'Cannot identify the operating system: /etc/os-release is missing.\n' >&2
  exit 1
fi

# shellcheck disable=SC1091
source /etc/os-release
if [[ ${ID:-} != ubuntu ]]; then
  printf 'This episode supports Ubuntu; detected ID=%s.\n' "${ID:-unknown}" >&2
  exit 1
fi

target_user=${1:-${SUDO_USER:-}}
if [[ -n ${target_user} ]]; then
  if ! getent passwd "${target_user}" >/dev/null; then
    printf 'The requested account does not exist: %s\n' "${target_user}" >&2
    exit 1
  fi
  if [[ $(id -u "${target_user}") -eq 0 ]]; then
    printf 'Refusing to add the root account to virtualization groups. Specify a non-root administrator.\n' >&2
    exit 1
  fi
else
  printf 'INFO: No non-root account was supplied. Packages will be installed, but no user will be added to groups.\n'
fi

packages=(
  cpu-checker
  qemu-system-x86
  libvirt-daemon-system
  libvirt-clients
  virtinst
)

printf 'Installing KVM/libvirt packages on %s %s...\n' "${NAME}" "${VERSION_ID:-unknown}"
apt-get update
apt-get install -y "${packages[@]}"

systemctl enable --now libvirtd

if [[ -n ${target_user} ]]; then
  for group in libvirt kvm; do
    if ! getent group "${group}" >/dev/null; then
      printf 'Expected group is missing after package installation: %s\n' "${group}" >&2
      exit 1
    fi
    if id -nG "${target_user}" | tr ' ' '\n' | grep -Fxq "${group}"; then
      printf 'Account %s already belongs to %s.\n' "${target_user}" "${group}"
    else
      adduser "${target_user}" "${group}"
    fi
  done
fi

uri=qemu:///system
if virsh --connect "${uri}" net-info default >/dev/null 2>&1; then
  if ! virsh --connect "${uri}" net-info default | grep -Eq '^Active:[[:space:]]+yes$'; then
    virsh --connect "${uri}" net-start default
  fi
  virsh --connect "${uri}" net-autostart default
else
  printf 'WARNING: The packaged default libvirt network was not found. See NOTES.md before defining a replacement.\n' >&2
fi

printf '\nInstallation complete.\n'
if [[ -n ${target_user} ]]; then
  printf 'Sign out and back in as %s, then run ./verify-kvm-host.sh.\n' "${target_user}"
else
  printf 'Add a trusted administrator to libvirt and kvm, refresh the login session, then run ./verify-kvm-host.sh.\n'
fi

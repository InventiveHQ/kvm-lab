virsh Tutorial: Safely Manage KVM Virtual Machines

Follow the complete KVM and virsh series and build commands with the free InventiveHQ Virsh Command Builder:
https://inventivehq.com/tools/developer/virsh-command-builder

COMPANION GUIDE
https://inventivehq.com/blog/virsh-commands-kvm-cheat-sheet

DOWNLOADABLE LAB SCRIPTS
https://github.com/InventiveHQ/kvm-lab/tree/episode-03-v1/episodes/03-manage-kvm-with-virsh

COMMANDS USED IN THIS VIDEO

Connect to the correct libvirt service:
$ virsh --connect qemu:///system list --all
$ virsh --connect qemu:///session list --all
$ virsh --connect qemu+ssh://admin@kvm-host01/system list --all

Record the VM's current state:
$ virsh dominfo demo-ubuntu01
$ virsh domblklist demo-ubuntu01
$ virsh domifaddr demo-ubuntu01 --source lease
$ virsh dumpxml demo-ubuntu01 --inactive > before.xml

Change CPU and memory for the running VM and its persistent definition:
$ virsh setvcpus demo-ubuntu01 4 --live --config
$ virsh dominfo demo-ubuntu01
$ virsh setmem demo-ubuntu01 4096MiB --live --config

Verify the live and persistent result:
$ virsh dominfo demo-ubuntu01
$ virsh dumpxml demo-ubuntu01 --inactive > after.xml
$ diff -u before.xml after.xml

Run inside the guest:
$ lscpu | grep -E 'On-line|Off-line'
$ for cpu in /sys/devices/system/cpu/cpu*/online; do [ "$(cat "$cpu")" = 0 ] && echo 1 | sudo tee "$cpu"; done
$ nproc && free -h

Recover console or address access:
$ virsh ttyconsole demo-ubuntu01
$ virsh console demo-ubuntu01 --safe
$ virsh domifaddr demo-ubuntu01 --source lease
$ virsh domifaddr demo-ubuntu01 --source agent

Use graceful lifecycle operations:
$ virsh reboot demo-ubuntu01
$ virsh domstate demo-ubuntu01 --reason
$ virsh shutdown demo-ubuntu01
$ virsh save demo-ubuntu01 demo.state --verbose

DESTRUCTIVE EXAMPLES — inspect storage before running either undefine command:
$ virsh domblklist old-vm --details
$ virsh undefine old-vm
$ virsh undefine old-vm --remove-all-storage

00:00 What we are going to accomplish
00:34 What you need
01:15 Connect to the host
01:50 Inspect and record the current state
02:26 Plan the change
03:05 Change CPU and memory
03:42 Verify the result
04:30 Console and address recovery
05:10 Reboot and shut down safely
05:51 Safe VM removal
06:30 Recap and command builder

Commands were validated in the InventiveHQ disposable nested-KVM lab.

#Linux #KVM #libvirt #virsh #Virtualization

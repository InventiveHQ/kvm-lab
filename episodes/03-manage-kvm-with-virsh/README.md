# Episode 3: Manage a KVM VM safely with virsh

Inspect and manage the `demo-ubuntu01` guest created in Episode 2. This episode
covers connection scope, inventory, live and persistent CPU/memory changes,
guest-side verification, console recovery, graceful lifecycle operations, and
safe retirement.

- Companion article: https://inventivehq.com/blog/virsh-commands-kvm-cheat-sheet
- Virsh Command Builder: https://inventivehq.com/tools/developer/virsh-command-builder
- Release tag: `episode-03-v1`
- Previous episode: `../02-create-ubuntu-vm/`

## Safe walkthrough

Start with read-only inventory:

```bash
./inventory-vm.sh
```

Apply the demonstrated resource change only after reviewing the baseline:

```bash
./apply-resource-change.sh
```

The script changes the running and persistent definition to 4 vCPUs and 4 GiB.
Linux may leave newly hot-added CPUs offline; the script prints the guest-side
command used to online them explicitly.

Review `COMMANDS.md` before running lifecycle or retirement commands. Commands
such as `destroy`, `reset`, and `undefine --remove-all-storage` are documented
as danger-zone operations and are not included in the safe scripts.

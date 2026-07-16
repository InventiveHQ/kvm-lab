# Contributing

Contributions should remain reproducible, narrowly scoped, and safe by default.

- Run ShellCheck on shell scripts.
- Use `set -Eeuo pipefail` for executable Bash scripts.
- Parameterize VM names, paths, networks, and connection URIs.
- Require confirmation before deleting a domain, volume, or network.
- Never commit credentials, private keys, VM images, or production logs.
- Document prerequisites, expected output, verification, and cleanup.
- Keep episode behavior aligned with its companion article and video.


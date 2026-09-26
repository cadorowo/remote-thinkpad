# Remote vibes workspace

This local workspace is a navigation layer. The real projects and their state live on the remote machine.

- Connect with `ssh ggg@100.74.82.76`; the remote `~/vibes` directory is the source of truth.
- `server` holds local governance and tooling. Each other local project directory is a launcher for the identically named remote project.
- From a project launcher, derive the remote path from its directory name and do substantive work in `~/vibes/<project>` over SSH.
- Do not copy remote project contents into local launchers. If creating or renaming a remote project during a task, keep its local launcher consistent when possible.
- Before any project work, connect over SSH and read `/home/ggg/vibes/<project>/AGENTS.md` if present. This is mandatory; its project-specific governance takes precedence over these general instructions. Also read any nested `AGENTS.md` that governs files being changed.
- Inspect live remote state instead of recording changing inventories, versions, services, or troubleshooting notes here.
- Use `./reconcile.sh` to discover remote project directories and create missing launchers. It reports unmatched local launchers and does not delete them.

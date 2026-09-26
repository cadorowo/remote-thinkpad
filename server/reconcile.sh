#!/usr/bin/env bash
set -euo pipefail

remote="${REMOTE_HOST:-ggg@100.74.82.76}"
remote_root="${REMOTE_VIBES_PATH:-/home/ggg/vibes}"
local_root="$(cd -- "$(dirname -- "$0")/.." && pwd)"

projects="$(ssh -o BatchMode=yes "$remote" "find '$remote_root' -mindepth 1 -maxdepth 1 -type d -printf '%f\\n' | sort")"

created=0
while IFS= read -r name; do
  [[ -n "$name" && "$name" != .* && "$name" != server ]] || continue
  launcher="$local_root/$name"
  if [[ ! -d "$launcher" ]]; then
    mkdir -- "$launcher"
    ln -s ../server/PROJECT-LAUNCHER.md "$launcher/AGENTS.md"
    printf 'created %s\n' "$name"
    ((created += 1))
  elif [[ ! -e "$launcher/AGENTS.md" && ! -L "$launcher/AGENTS.md" ]]; then
    ln -s ../server/PROJECT-LAUNCHER.md "$launcher/AGENTS.md"
    printf 'linked %s/AGENTS.md\n' "$name"
  fi
done <<< "$projects"

orphans=0
while IFS= read -r -d '' path; do
  name="${path##*/}"
  [[ "$name" == server || "$name" == .* ]] && continue
  if ! printf '%s\n' "$projects" | grep -Fxq -- "$name"; then
    printf 'unmatched local launcher (kept): %s\n' "$name"
    ((orphans += 1))
  fi
done < <(find "$local_root" -mindepth 1 -maxdepth 1 -type d -print0)

printf 'remote projects: %d; launchers created: %d; unmatched local launchers: %d\n' \
  "$(printf '%s\n' "$projects" | awk 'NF && $0 !~ /^\./ && $0 != "server" { count++ } END { print count+0 }')" \
  "$created" "$orphans"

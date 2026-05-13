#!/bin/bash
set -euo pipefail

out="${1:?usage: monitor-stop.sh out-dir}"
h=$(hostname)
for f in "$out/${h}.pid."*; do
  [ -e "$f" ] || continue
  kill "$(cat "$f")" 2>/dev/null || true
  rm -f "$f"
done
echo "$h: monitor stopped"

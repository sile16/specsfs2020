#!/bin/bash
set -euo pipefail

base="${1:?usage: mount-fb.sh base-mountpoint src1 [src2 ...]}"
shift
opts="vers=3,hard,proto=tcp,nconnect=16"

i=0
for src in "$@"; do
  i=$((i + 1))
  dst="${base}-${i}"
  mkdir -p "$dst"
  if mountpoint -q "$dst"; then
    fuser -k -9 -m "$dst" 2>/dev/null || true
    sleep 1
    umount -fl "$dst"
  fi
  mount -t nfs -o "$opts" "$src" "$dst"
  mountpoint -q "$dst" || { echo "$(hostname): FAILED to mount $dst" >&2; exit 1; }
  echo "$(hostname): $src on $dst"
done

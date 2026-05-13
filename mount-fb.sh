#!/bin/bash
set -euo pipefail

src="${1:?usage: mount-fb.sh server:/export base-mountpoint [count=1]}"
base="${2:?usage: mount-fb.sh server:/export base-mountpoint [count=1]}"
n="${3:-1}"
opts="vers=3,hard,proto=tcp,nconnect=16,nosharecache"

for i in $(seq 1 "$n"); do
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

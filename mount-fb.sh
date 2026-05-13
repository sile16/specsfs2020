#!/bin/bash
set -euo pipefail

src="${1:?usage: mount-fb.sh server:/export base-mountpoint [count=1]}"
base="${2:?usage: mount-fb.sh server:/export base-mountpoint [count=1]}"
n="${3:-1}"
opts="vers=3,rsize=1048576,wsize=1048576,hard,proto=tcp,nconnect=16,nosharecache"

for i in $(seq 1 "$n"); do
  dst="${base}-${i}"
  mkdir -p "$dst"
  mountpoint -q "$dst" && umount "$dst"
  mount -t nfs -o "$opts" "$src" "$dst"
  echo "$(hostname): $src on $dst"
done

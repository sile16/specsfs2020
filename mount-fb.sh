#!/bin/bash
set -euo pipefail

src="${1:?usage: mount-fb.sh server:/export mountpoint}"
dst="${2:?usage: mount-fb.sh server:/export mountpoint}"
opts="vers=3,rsize=1048576,wsize=1048576,hard,proto=tcp,nconnect=16"

mkdir -p "$dst"
mountpoint -q "$dst" && umount "$dst"
mount -t nfs -o "$opts" "$src" "$dst"
echo "$(hostname): $src on $dst ($opts)"

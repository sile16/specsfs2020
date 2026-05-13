#!/bin/bash
set -euo pipefail

src="${1:?usage: mount-fb.sh server:/export mountpoint}"
dst="${2:?usage: mount-fb.sh server:/export mountpoint}"

mkdir -p "$dst"
mountpoint -q "$dst" || mount -t nfs -o vers=3,rsize=1048576,wsize=1048576,hard,proto=tcp "$src" "$dst"
echo "$(hostname): $src on $dst"

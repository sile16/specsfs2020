#!/usr/bin/env python3
import os
import sys
from pypureclient import flashblade as fb

count = int(sys.argv[1]) if len(sys.argv) > 1 else 4
prefix = sys.argv[2] if len(sys.argv) > 2 else "fs-spec-"
mgmt = os.environ.get("FLASHBLADE_MGMT", "10.23.33.50")
token = os.environ["FLASHBLADE_API_KEY"]

c = fb.Client(target=mgmt, api_token=token)

for i in range(1, count + 1):
    name = f"{prefix}{i}"
    body = fb.FileSystemPost(
        nfs=fb.NfsPatch(v3_enabled=True, v4_1_enabled=False, export_policy=fb.Reference(name="local")),
        fast_remove_directory_enabled=False,
        snapshot_directory_enabled=False,
        hard_limit_enabled=False,
    )
    r = c.post_file_systems(names=[name], file_system=body)
    print(name, r.status_code, getattr(r, "errors", None) or "ok")

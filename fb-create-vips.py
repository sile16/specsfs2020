#!/usr/bin/env python3
import os
import sys
from pypureclient import flashblade as fb

start = int(sys.argv[1]) if len(sys.argv) > 1 else 57
end = int(sys.argv[2]) if len(sys.argv) > 2 else 74
subnet = sys.argv[3] if len(sys.argv) > 3 else "pod-33"
prefix = sys.argv[4] if len(sys.argv) > 4 else "10.23.33."

mgmt = os.environ.get("FLASHBLADE_MGMT", "10.23.33.50")
token = os.environ["FLASHBLADE_API_KEY"]
c = fb.Client(target=mgmt, api_token=token)

for n in range(start, end + 1):
    name = f"data{n}"
    body = fb.NetworkInterface(
        address=f"{prefix}{n}",
        services=["data"],
        type="vip",
        subnet={"name": subnet},
    )
    r = c.post_network_interfaces(names=[name], network_interface=body)
    print(name, r.status_code, getattr(r, "errors", None) or "ok")

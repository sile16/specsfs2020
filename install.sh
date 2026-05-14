#!/bin/bash
set -euo pipefail

dnf install -y git nfs-utils java-21-openjdk-headless sysstat iproute numactl

systemctl disable --now firewalld 2>/dev/null || true

echo "$(hostname): installed"

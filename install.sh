#!/bin/bash
set -euo pipefail

dnf install -y git nfs-utils java-21-openjdk-headless

echo "$(hostname): installed"

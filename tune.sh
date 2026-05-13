#!/bin/bash
set -euo pipefail

cat >/etc/sysctl.d/99-specsfs.conf <<EOF
# fs.nr_open=1048576  # RHEL 9.2 default 1073741816, leave alone
net.core.wmem_max=25165824
net.core.rmem_max=25165824
net.core.netdev_max_backlog=300000
net.ipv4.tcp_rmem=4096 87380 25165824
net.ipv4.tcp_wmem=4096 87380 25165824
net.ipv4.tcp_mem=2457600 2457600 2457600
EOF
sysctl --system >/dev/null

cat >/etc/security/limits.d/99-specsfs.conf <<EOF
root - nofile 1048576
root - nproc  65000
EOF

mkdir -p /etc/systemd/system.conf.d /etc/systemd/user.conf.d
for d in system user; do
  cat >/etc/systemd/$d.conf.d/99-specsfs.conf <<EOF
[Manager]
DefaultLimitNOFILE=1048576
EOF
done
systemctl daemon-reexec

echo "$(hostname): tuned"

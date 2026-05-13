#!/bin/bash
set -euo pipefail

bench="${1:?usage: run.sh benchmark load tag [mounts=8]}"
load="${2:?}"
tag="${3:?}"
mounts="${4:-8}"

base=/mnt/specsfs2020
sfsdir=/root/spec/SPECstorage2020
mondir=/home/specsfs2020/monitor/$tag
resdir=/root/spec/results.$tag
rc=$sfsdir/sfs_rc.$tag

hosts=$(grep -v "^$(hostname)\$" /root/h.txt)

cm=""
for m in $(seq 1 $mounts); do
  for h in $hosts; do cm="$cm $h:$base-$m/data"; done
done

cat >$rc <<EOF
CLIENT_MOUNTPOINTS=$cm
USER=root
EXEC_PATH=$base-1/netmist
BENCHMARK=$bench
LOAD=$load
INCR_LOAD=$load
NUM_RUNS=1
NETMIST_LICENSE_KEY=9072
NETMIST_LICENSE_KEY_PATH=/tmp/netmist_license_key
IPV6_ENABLE=0
EOF

mv $base-1/data $base-1/data.old.$$ 2>/dev/null || true
mkdir -p $base-1/data

pssh -h /root/h.txt -i -t 15 -- "pkill -9 monitor.sh 2>/dev/null; pkill -9 mpstat 2>/dev/null; pkill -9 sar 2>/dev/null; pkill -9 sadc 2>/dev/null; mkdir -p $mondir; ~/specsfs2020/monitor.sh $mondir 5"

rm -rf $resdir
mkdir -p $resdir
cd $sfsdir
nohup python3 SM2020 -r $rc -s $tag -d $resdir > $resdir/sm2020.out 2>&1 &
echo "$tag launched -> $resdir (pid $!)"

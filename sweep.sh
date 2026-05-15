#!/bin/bash
set -u

load="${1:-2200}"
prime=$(hostname)
gens=$(grep -v "^$prime\$" /root/h.txt)
mb=/mnt/specsfs2020

remount() {
  local spec=$1
  for h in $gens; do
    b=$(echo "$h" | sed 's/.*-//'); b=$((55 + (b - 21) * 4))
    case $spec in
      m1_1fs)   args="10.23.33.55:/fs-spec-1" ;;
      m4_1fs)   args="10.23.33.55:/fs-spec-1 10.23.33.55:/fs-spec-1 10.23.33.55:/fs-spec-1 10.23.33.55:/fs-spec-1" ;;
      m4_4fs)   args="10.23.33.55:/fs-spec-1 10.23.33.55:/fs-spec-2 10.23.33.55:/fs-spec-3 10.23.33.55:/fs-spec-4" ;;
      m4_20vip_1fs) args="10.23.33.$b:/fs-spec-1 10.23.33.$((b+1)):/fs-spec-1 10.23.33.$((b+2)):/fs-spec-1 10.23.33.$((b+3)):/fs-spec-1" ;;
      m4_20vip_4fs) args="10.23.33.$b:/fs-spec-1 10.23.33.$((b+1)):/fs-spec-2 10.23.33.$((b+2)):/fs-spec-3 10.23.33.$((b+3)):/fs-spec-4" ;;
    esac
    ssh "$h" "for i in 1 2 3 4 5 6 7 8; do umount -fl $mb-\$i 2>/dev/null; done; ~/specsfs2020/mount-fb.sh $mb $args" >/dev/null 2>&1
  done
  for i in 1 2 3 4 5 6 7 8; do umount -fl $mb-$i 2>/dev/null; done
  ~/specsfs2020/mount-fb.sh $mb 10.23.33.55:/fs-spec-1 >/dev/null 2>&1
}

for spec in m1_1fs m4_1fs m4_4fs m4_20vip_1fs m4_20vip_4fs; do
  case $spec in m1_1fs) mc=1 ;; *) mc=4 ;; esac
  echo "$(date +%T) === $spec load=$load mounts=$mc ==="
  remount "$spec"
  ~/specsfs2020/run.sh EDA_BLENDED "$load" "sw_${spec}" "$mc" >/dev/null 2>&1
  while pgrep -f SM2020 >/dev/null; do sleep 30; done
  tail -1 /root/spec/results.sw_${spec}/sfssum_sw_${spec}.txt 2>/dev/null
done
echo "$(date +%T) === sweep done ==="

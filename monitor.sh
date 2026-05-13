#!/bin/bash
set -euo pipefail

out="${1:-/home/specsfs2020/monitor}"
iv="${2:-5}"
mkdir -p "$out"
h=$(hostname)

(while :; do date -u +%FT%TZ; nstat -az; echo ---; done) > "$out/${h}.nstat" 2>&1 &
echo $! > "$out/${h}.pid.nstat"

mpstat -P ALL "$iv" > "$out/${h}.mpstat" 2>&1 &
echo $! > "$out/${h}.pid.mpstat"

sar -n DEV "$iv" > "$out/${h}.sar-dev" 2>&1 &
echo $! > "$out/${h}.pid.sar-dev"

sar -r "$iv" > "$out/${h}.sar-mem" 2>&1 &
echo $! > "$out/${h}.pid.sar-mem"

(while :; do date -u +%FT%TZ; ss -tim; echo ---; sleep "$iv"; done) > "$out/${h}.ss" 2>&1 &
echo $! > "$out/${h}.pid.ss"

echo "$h: monitor started -> $out"

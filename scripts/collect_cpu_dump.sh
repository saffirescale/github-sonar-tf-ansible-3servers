#!/bin/bash
# Linux CPU / process snapshot collector
OUTDIR=/tmp/cpu_dump_$(date +%Y%m%d%H%M%S)
mkdir -p "$OUTDIR"
echo "Collecting top output..."
top -b -n 1 > $OUTDIR/top.txt
echo "Collecting ps output..."
ps aux --sort=-%cpu | head -n 50 > $OUTDIR/ps_top.txt
echo "Collecting vmstat..."
vmstat 1 5 > $OUTDIR/vmstat.txt
echo "Collecting iostat (if available)..."
if command -v iostat >/dev/null 2>&1; then
  iostat -xz 1 3 > $OUTDIR/iostat.txt
fi
echo "Tarballing results..."
tar -czf /tmp/cpu_snapshot.tar.gz -C /tmp $(basename $OUTDIR)
echo "Saved to /tmp/cpu_snapshot.tar.gz"

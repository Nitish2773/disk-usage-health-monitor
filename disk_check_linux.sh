#!/bin/bash

echo "======= Disk Health & Usage Report (Linux) ======="
echo "Date: $(date)"
echo

echo "[1] Mounted Filesystems:"
df -h
echo

echo "[2] Disk Inodes:"
df -i
echo

echo "[3] Top 5 Largest Directories in /:"
du -ahx / | sort -rh | head -n 5
echo

echo "[4] Partition Layout:"
lsblk
echo

echo "[5] Disk Health (SMART Data):"
sudo smartctl -H /dev/sda

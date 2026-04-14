#!/bin/bash
sudo kill -9 $(pgrep -f qemu-system-aarch64) 2>/dev/null
sleep 1
pgrep -f qemu-system-aarch64 || echo "VM killed"

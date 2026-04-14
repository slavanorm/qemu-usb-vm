#!/bin/bash
# Alpine QEMU VM — ext4 USB partition as virtio disk
# Interact: ./vm-cmd.sh "command"
# Kill: ./kill-vm.sh

ISO="$HOME/second_machine/alpine-virt-3.21.3-aarch64.iso"
UEFI="/opt/homebrew/share/qemu/edk2-aarch64-code.fd"
DISK="/dev/disk4s2"

diskutil unmountDisk /dev/disk4 2>/dev/null

sudo -n /opt/homebrew/bin/qemu-system-aarch64 \
  -machine virt,highmem=off \
  -accel hvf \
  -cpu host \
  -m 512 \
  -smp 1 \
  -bios "$UEFI" \
  -cdrom "$ISO" \
  -boot d \
  -display none \
  -chardev socket,id=char-serial,path=/tmp/qemu-serial.sock,server=on,wait=off \
  -serial chardev:char-serial \
  -drive file="$DISK",format=raw,if=virtio,cache=none \
  -nic user,hostfwd=tcp::10022-:22 \
  -daemonize \
  -pidfile /tmp/qemu-alpine.pid

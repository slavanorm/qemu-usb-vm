# qemu-usb-vm

Edit ext4/btrfs/xfs USB drives on macOS via a minimal QEMU Alpine VM.

macOS can't write Linux filesystems. This boots a 75MB Alpine ISO in RAM, passes your USB partition as a virtio block device, and exposes a serial console for commands. No disk images, no Lima, no Docker.

## Setup

```bash
brew install qemu
```

Configure passwordless sudo (one-time, run in terminal):
```bash
printf 'YOU ALL=(ALL) NOPASSWD: /opt/homebrew/bin/qemu-system-aarch64\nYOU ALL=(ALL) NOPASSWD: /bin/kill\nYOU ALL=(ALL) NOPASSWD: /usr/bin/python3\n' | sudo tee /etc/sudoers.d/qemu > /dev/null
```

Find your USB partition:
```bash
diskutil list external
```

Update `DISK=` in `start-vm.sh` to match (e.g. `/dev/disk4s2`).

## Usage

```bash
./start-vm.sh                              # boot VM (downloads ISO on first run)
./vm-cmd.sh "mount /dev/vdb /mnt && ls /mnt"  # run commands
./vm-cmd.sh "sed -i 's/old/new/' /mnt/file"   # edit files
./stop-vm.sh                               # graceful shutdown
./kill-vm.sh                               # force kill
```

USB partition appears as `/dev/vdb` inside the VM (`/dev/vda` is the ISO).

## Why not X?

- **Lima**: no USB passthrough, SSH key injection broken with stock Alpine
- **UTM**: no CLI
- **USB passthrough** (`usb-host`): macOS SIP blocks `libusb_detach_kernel_driver`
- **ext4fuse**: read-only

This passes the raw block device directly via virtio — no USB stack involved.

## License

MIT

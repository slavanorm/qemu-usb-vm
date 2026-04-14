#!/bin/bash
# Gracefully unmount USB and poweroff VM
sudo -n /usr/bin/python3 -c "
import socket, time

sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
sock.connect('/tmp/qemu-serial.sock')
sock.settimeout(5)

try:
    while sock.recv(4096): pass
except: pass

sock.sendall(b'umount /mnt 2>/dev/null; poweroff\n')
time.sleep(3)
try: print(sock.recv(4096).decode(errors='replace'))
except: pass
sock.close()
"

sleep 2
pgrep -f qemu-system-aarch64 || echo "VM stopped"

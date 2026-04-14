#!/bin/bash
# Send command to QEMU VM via serial console socket
SOCK="/tmp/qemu-serial.sock"
CMD="$*"
MARKER="__DONE_$$__"

sudo -n /usr/bin/python3 -c "
import socket, time

sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
sock.connect('${SOCK}')
sock.settimeout(5)

# drain pending output
try:
    while sock.recv(4096): pass
except: pass

# login as root
sock.sendall(b'root\n')
time.sleep(1)
try: sock.recv(4096)
except: pass

# send command
sock.sendall(b'''${CMD}; printf \"${MARKER}\\\\n\"
''')
time.sleep(0.5)

out = b''
for _ in range(20):
    try:
        chunk = sock.recv(4096)
        out += chunk
        if b'${MARKER}' in out:
            break
    except:
        break
    time.sleep(0.3)

sock.close()

text = out.decode(errors='replace')
for line in text.split('\n'):
    if '${MARKER}' in line:
        break
    print(line)
"

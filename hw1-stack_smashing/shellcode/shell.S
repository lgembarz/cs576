# program just needs to call execve and exit!
        .global _start

        .text
_start:
	# syscall to execve
	mov $59, %rax 			# calling execve
	mov $path_to_bash, %rdi
	push $path_to_bash		#push path into stack to be first val of argv
	push $0				# push null ptr into stack to be second val of argv
	mov %rsp, %rsi			# push stack as argv[]
	mov $0, %rdx			# 0 read as null pointer, nothing passed
	syscall

	# above syscall works if rsi is $0, so can't really tell if argv[0] passsed correctly
	# doesn't matter anyway?

        # exit(0)
	mov	$60, %rax
        xor     %rdi, %rdi              # we want return code 0
        syscall                         # invoke operating system to exit
path_to_bash:
        .ascii  "/bin/bash"

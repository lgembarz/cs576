# program needs to open file, read data, write to stdout, exit
        .global _start

        .text
_start:
	# syscall to open
	mov 	$2, %rax		# system call num 2 is open
	mov	$path_to_passwd, %rdi
	mov	$0, %rsi		# $0 is O_RDONLY according to fcntl.h
	mov	$0, %rdx		# mode shouldn't matter anyway (no new file)
	syscall 			# invoke os to do execute the syscall

	sub 	$10000, %rsp		# subtract from rsp to allocate mem in buf

	#syscall to read
	mov %rax, %rdi			# return of open is fd of read
	mov $0, %rax 			# system call num  0 is read
	mov %rsp, %rsi 			# allocated space in buffer passed in to write to
	mov $10000, %rdx		# read entire buffer
	syscall

	# syscall to write
	mov	$1, %rax 		# system call num 1 is write
	mov	$1, %rdi 		# file descriptor 1 is stdout
	mov 	%rsp, %rsi		# writing from earlier allocated buffer
	mov	$10000, %rdx		# write to whole buffer
	syscall

        # exit(0)
	mov	$60, %rax
        xor     %rdi, %rdi              # we want return code 0
        syscall                         # invoke operating system to exit
path_to_passwd:
        .ascii  "/etc/passwd"

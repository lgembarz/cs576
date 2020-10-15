# program needs to open file, make buf of right size, read data, write to stdout, exit
        .global _start

        .text
_start:
	# syscall to open
	mov 	$2, %rax		# system call num 2 is open
	mov	$path_to_passwd, %rdi
	mov	$0, %rsi		# $0 is O_RDONLY according to fcntl.h
	mov	$0, %rdx		# mode shouldn't matter anyway (no new file)
	syscall 			# invoke os to do execute the syscall

	mov %rax, %r8			# save fd of file in temp register r8
	sub $120, %rsp 			# allocate memory for statbuf (8 * 15)

	# find size of file using fstat
	mov $4, %rax			# system call num 4 is stat
	mov $path_to_passwd, %rdi
	mov %rsp, %rsi			# stat outputs file info in buffer
	syscall

	#allocate appropriate amount of memory using resulting statbuf
	add $48, %rsp			# move to filesize in statbuf (8*6)
	pop %r9				# pop size of file to temp register (adds by 4)
	add $68, %rsp			# free statbuf memory
	sub %r9, %rsp			# allocate filesize amount of memory for read/write to use


	# syscall to read
	mov %r8, %rdi			# return of open is fd of read
	mov $0, %rax 			# system call num  0 is read
	mov %rsp, %rsi 			# allocated space in buffer passed in to write to
	mov %r9, %rdx			# read entire buffer
	syscall

	# syscall to write
	mov	$1, %rax 		# system call num 1 is write
	mov	$1, %rdi 		# file descriptor 1 is stdout
	mov 	%rsp, %rsi		# writing from earlier allocated buffer
	mov	%r9, %rdx		# write to whole buffer
	syscall

        # exit(0)
	mov	$60, %rax
        xor     %rdi, %rdi              # we want return code 0
        syscall                         # invoke operating system to exit
path_to_passwd:
        .ascii  "/etc/passwd"

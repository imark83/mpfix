	.text
	.globl _fpadd
_fpadd:
	pushq	%rbx	

	#compute %rcx = SIZE/8, size stored in %ecx
	movq	%rdx, %rbx		# preserve %rdx (pointer to op1->data)
	movl	%ecx, %eax		# put in %eax total size of op1 in bytes
	xorl	%edx, %edx		# set %edx = 0
	movl	$0x8, %ecx		# set %ecx = 8
	idivl	%ecx			# %eax = (%edx:%eax) / 8  (we ignore remainder)
	movl	%eax, %ecx		# %ecx = size/8 (number of long ints)
	movq	%rbx, %rdx		# restore %rdx

	
	# we have %rdx ponter to op1->data
	# we have %r8  pointer to op2->data
	# set %ebx pointer to rop->data
	movq	8(%rdi), %rbx	


	# summation loop
	# we use %rcx as counter. Start at (size/8 - 1) 
	subq	$0x1, %rcx		

	movq	(%rdx, %rcx, 8), %rdi	# %rdi = op1->data[size-1]
	movq	%rdi, (%rbx, %rcx, 8)   # rop->data[size-1] = %rdi

	movq	(%r8, %rcx, 8), %rdi	# %rdi = op2->data[size-1]
	addq	%rdi, (%rbx, %rcx, 8)	# rop->data[size-1] += %rdi

	cmpl	$0x0, %ecx		# check if finished (size = 8)
	je	LAddEnd			
LAddLoop:
	subq	$0x1, %rcx		# substract 1 from counter and repeat
	movq	(%rdx, %rcx, 8), %rdi
	movq	%rdi, (%rbx, %rcx, 8)
	movq	(%r8, %rcx, 8), %rdi
	adcq	%rdi, (%rbx, %rcx, 8)	# we add with carry!
	cmpl	$0x0, %ecx
	jg	LAddLoop
LAddEnd:
	popq	%rbx
	ret

#	cmpl	$0, (%rbx)
#	je	L1
#	movl	$0, %eax
#L3:
#	movq	8(%rbx), %rdx
#	movq	$0, (%rdx,%rax,8)
#	addq	$1, %rax
#	mov	(%rbx), %edx
#	cmpq	%rax, %rdx
#	jg	L3
#L1:
#	popq	%rbx

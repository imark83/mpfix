.text

.globl fixadd
.type fixadd, @function
# char int fixadd (fix_t *rop, fix_t op1, fix_t op2);    returns overflow carry (0 or 1)
fixadd:
	pushq	%rbx	

	#compute %rcx = SIZE, size stored in %ecx
	movl	%ecx, %ecx			# put in %eax total size of op1 in quad words


	
	# we have %rdx ponter to op1->data
	# we have %r8  pointer to op2->data
	# set %ebx pointer to rop->data
	movq	8(%rdi), %rbx	


	# summation loop
	# we use %rcx as counter. Start at (size) 
	movq	$0x1, %rsi			# overflow flag to return

	movq	-8(%rdx, %rcx, 8), %rdi		# %rdi = op1->data[size-1]
	movq	%rdi, -8(%rbx, %rcx, 8) 	# rop->data[size-1] = %rdi
	
	movq	-8(%r8, %rcx, 8), %rdi		# %rdi = op2->data[size-1]
	addq	%rdi, -8(%rbx, %rcx, 8)		# rop->data[size-1] += %rdi

	decq	%rcx
	jz	LAddEnd			
LAddLoop:
	movq	-8(%rdx, %rcx, 8), %rdi		# %rdi = op1->data[i-1]
	movq	%rdi, -8(%rbx, %rcx, 8)
	movq	-8(%r8, %rcx, 8), %rdi
	adcq	%rdi, -8(%rbx, %rcx, 8)		# we add with carry!
	movq	$0x0, %rax
	cmovoq	%rsi, %rax			# store in %rax overflow flag
	decq	%rcx				# substract 1 from counter and repeat
	jnz	LAddLoop
LAddEnd:
	popq	%rbx
	ret



.globl fixsub
.type fixsub, @function
# char fixsub (fix_t *rop, fix_t op1, fix_t op2);    returns overflow carry (0 or 1)
fixsub:
	pushq	%rbx	


	#compute %rcx = SIZE, size stored in %ecx
	movl	%ecx, %ecx			# put in %eax total size of op1 in quad words

	
	# we have %rdx ponter to op1->data
	# we have %r8  pointer to op2->data
	# set %ebx pointer to rop->data
	movq	8(%rdi), %rbx	


	# summation loop
	# we use %rcx as counter. Start at (size) 
	movq	$0x1, %rsi			# overflow flag to return

	movq	-8(%rdx, %rcx, 8), %rdi		# %rdi = op1->data[size-1]
	movq	%rdi, -8(%rbx, %rcx, 8) 	# rop->data[size-1] = %rdi
	
	movq	-8(%r8, %rcx, 8), %rdi		# %rdi = op2->data[size-1]
	subq	%rdi, -8(%rbx, %rcx, 8)		# rop->data[size-1] += %rdi

	decq	%rcx
	jz	LSubEnd			
LSubLoop:
	movq	-8(%rdx, %rcx, 8), %rdi		# %rdi = op1->data[i-1]
	movq	%rdi, -8(%rbx, %rcx, 8)
	movq	-8(%r8, %rcx, 8), %rdi
	sbbq	%rdi, -8(%rbx, %rcx, 8)		# we sub with carry!
	movq	$0x0, %rax
	cmovoq	%rsi, %rax			# store in %rax overflow flag
	decq	%rcx				# substract 1 from counter and repeat
	jnz	LSubLoop
LSubEnd:
	popq	%rbx
	ret


.globl fixmul_long
.type fixmul_long, @function
# void fixmul_long (fix_t *rop, fix_t op1, long op2);
fixmul_long:
	pushq	%rbx
	# allocate free space for temp storage
	pushq	%rdi				# preserve rdi
	pushq	%rsi				# preserve rsi
	pushq	%rdx				# preserve rdx
	pushq	%rcx				# preserve rcx
	pushq	%r8				# preserve r8
	movl	%edx, %edi			# rdi = size
	sall	$3, %edi			# multiply by 8 bytes per block
	call	malloc
	popq	%r8
	popq	%rcx
	popq	%rdx
	popq	%rsi
	popq	%rdi

	movq	%rax, %rdi
	call	free


	#compute %rcx = SIZE, size stored in %ecx
	movl	%ecx, %ecx		# put in %eax total size of op1 in quad words



LMulLongEnd:
	popq	%rbx
	ret








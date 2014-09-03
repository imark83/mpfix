.text

.globl fixadd
.type fixadd, @function
fixadd:

	# rop = op1 + op2
	# char int fixadd (fix_t *rop, fix_t op1, fix_t op2);    returns overflow flag (0 or 1)
	# must preserve value of op2. op1 can be override (rop -> &op1)

	#########################################
	# 
	# WORK FRAME
	#
	# r10 -> rop->data
	# rdx -> op1.data
	# r8  -> op2.data
	# rcx -> size in quad words (also counter)
	# 
	#########################################

	
	#compute rcx = SIZE, size stored in %ecx
	movl	%ecx, %ecx		

	
	# we have %rdx ponter to op1->data
	# we have %r8  pointer to op2->data
	# set %r10 to point to rop->data
	movq	8(%rdi), %r10	


	# summation loop
	# we use %rcx as counter. Start at (size) 
	movq	$0x1, %rsi			# overflow flag value

	movq	-8(%rdx, %rcx, 8), %rdi		# %rdi = op1->data[size-1]
	movq	%rdi, -8(%r10, %rcx, 8)		# rop->data[size-1] = %rdi
	
	movq	-8(%r8, %rcx, 8), %rdi		# %rdi = op2->data[size-1]
	addq	%rdi, -8(%r10, %rcx, 8)		# rop->data[size-1] += %rdi

	movq	$0x0, %rax
	cmovoq	%rsi, %rax			# store in %rax overflow flag

	decq	%rcx
	jz	LAddEnd			
LAddLoop:
	movq	-8(%rdx, %rcx, 8), %rdi		# %rdi = op1->data[i-1]
	movq	%rdi, -8(%r10, %rcx, 8)

	movq	-8(%r8, %rcx, 8), %rdi
	adcq	%rdi, -8(%r10, %rcx, 8)		# we add with carry!

	movq	$0x0, %rax
	cmovoq	%rsi, %rax			# store in %rax overflow flag

	decq	%rcx				# substract 1 from counter and repeat
	jnz	LAddLoop
LAddEnd:
	ret



.globl fixsub
.type fixsub, @function
fixsub:

	# rop = op1 - op2
	# char int fixadd (fix_t *rop, fix_t op1, fix_t op2);    returns overflow flag (0 or 1)
	# must preserve value of op2. op1 can be override (rop -> &op1)

	#########################################
	# 
	# WORK FRAME
	#
	# r10 -> rop->data
	# rdx -> op1.data
	# r8  -> op2.data
	# rcx -> size in quad words (also counter)
	# 
	#########################################

	
	#compute rcx = SIZE, size stored in %ecx
	movl	%ecx, %ecx		

	
	# we have %rdx ponter to op1->data
	# we have %r8  pointer to op2->data
	# set %r10 to point to rop->data
	movq	8(%rdi), %r10	


	# substraction loop
	# we use %rcx as counter. Start at (size) 
	movq	$0x1, %rsi			# overflow flag value

	movq	-8(%rdx, %rcx, 8), %rdi		# %rdi = op1->data[size-1]
	movq	%rdi, -8(%r10, %rcx, 8)		# rop->data[size-1] = %rdi
	
	movq	-8(%r8, %rcx, 8), %rdi		# %rdi = op2->data[size-1]
	subq	%rdi, -8(%r10, %rcx, 8)		# rop->data[size-1] += %rdi

	movq	$0x0, %rax
	cmovoq	%rsi, %rax			# store in %rax overflow flag

	decq	%rcx
	jz	LSubEnd			
LSubLoop:
	movq	-8(%rdx, %rcx, 8), %rdi		# %rdi = op1->data[i-1]
	movq	%rdi, -8(%r10, %rcx, 8)

	movq	-8(%r8, %rcx, 8), %rdi
	sbbq	%rdi, -8(%r10, %rcx, 8)		# we add with carry!

	movq	$0x0, %rax
	cmovoq	%rsi, %rax			# store in %rax overflow flag

	decq	%rcx				# substract 1 from counter and repeat
	jnz	LSubLoop
LSubEnd:
	ret




.globl fixmul_long
.type fixmul_long, @function
fixmul_long:

loop:	
	xorq	%rax, %rax
	xorq	%rbx, %rbx
	movb	$0x7F,	%al
	movb	$0xFE,	%bl
	mulb	%bl
	xorq	%rax, %rax
	xorq	%rbx, %rbx
	movb	$0x7F,	%al
	movb	$0xFE,	%bl
	imulb	%bl

	xorq	%rax, %rax
	xorq	%rbx, %rbx
	movb	$0x7F,	%al
	movb	$0x80,	%bl
	mulb	%bl
	xorq	%rax, %rax
	xorq	%rbx, %rbx
	movb	$0x7F,	%al
	movb	$0x80,	%bl
	imulb	%bl

	xorq	%rax, %rax
	xorq	%rbx, %rbx
	movb	$0xFF,	%al
	movb	$0xFE,	%bl
	mulb	%bl
	xorq	%rax, %rax
	xorq	%rbx, %rbx
	movb	$0xFF,	%al
	movb	$0xFE,	%bl
	imulb	%bl

	jmp	loop

	xorq	%rax, %rax
	xorq	%rbx, %rbx
	movb	$0xFF,	%al
	movb	$0xFF,	%bl
	mulb	%bl
	xorq	%rax, %rax
	xorq	%rbx, %rbx
	movb	$0xFF,	%al
	movb	$0xFF,	%bl
	imulb	%bl




	# roph:ropl = op1 * op2
	# char int fixmul_long (unsigned long int *roph, fix_t *ropl, fix_t op1, unsigned long int op2); returns overflow flag (0 or 1)
	# must preserve value of op2. op1 can be override (rop -> &op1)

	#########################################
	# 
	# WORK FRAME
	#
	# r10 -> rop->data
	# rdx -> op1.data
	# r8  -> op2.data
	# rcx -> size in quad words (also counter)
	# 
	#########################################

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
	popq	%r8				# restore r8
	popq	%rcx				# restore rcx
	popq	%r10				# restore rdx on r10
	popq	%rsi				# restore rsi
						# we leave &rop on stack

	movq	%rax, %r9

	movq	%rax, %rdi
	call	free


	#compute %rcx = SIZE, size stored in %ecx
	movl	%ecx, %ecx		# put in %eax total size of op1 in quad words



LMulLongEnd:
	popq	%rbx
	ret








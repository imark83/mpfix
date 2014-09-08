.text

.globl ubigintAdd
.type ubigintAdd, @function
ubigintAdd:

	# rop = op1 + op2
	# char ubigintAdd (ubigint_t rop, ubigint_t op1, ubigint_t op2, int size);    returns carry flag (0 or 1)
	# must preserve value of op2. op1 can be override (rop -> &op1)

	#########################################
	#
	# INPUT ARGUMENTS
	# rdi -> &rop
	# rsi -> op1
	# rdx -> op2
	# rcx -> size
	#
	#########################################	

	#########################################
	# 
	# WORK FRAME
	#
	# rdi -> rop
	# rsi -> op1
	# rdx -> op2
	# rcx -> size in quad words (also counter)
	# 
	#########################################

	
	#compute rdix = rop
	movq	(%rdi), %rdi
	

	# summation loop
	# we use %rcx as counter. Start at (size) 
	movq	$0x1, %r8			# carry flag value

	movq	-8(%rsi, %rcx, 8), %r9		# %r9 = op1[size-1]
	movq	%r9, -8(%rdi, %rcx, 8)		# rop[size-1] = %r9
	
	movq	-8(%rdx, %rcx, 8), %r9		# %r9 = op2[size-1]
	addq	%r9, -8(%rdi, %rcx, 8)		# rop[size-1] += %r9

	movq	$0x0, %rax
	cmovoq	%r8, %rax			# store in %rax carry flag

	decq	%rcx
	jz	LAddEnd			
LAddLoop:
	movq	-8(%rsi, %rcx, 8), %r9		# %r9 = op1[size-1]
	movq	%r9, -8(%rdi, %rcx, 8)		# rop[size-1] = %r9
	
	movq	-8(%rdx, %rcx, 8), %r9		# %r9 = op2[size-1]
	adcq	%r9, -8(%rdi, %rcx, 8)		# rop[size-1] += %r9 WITH CARRY!

	movq	$0x0, %rax
	cmovoq	%r8, %rax			# store in %rax carry flag

	decq	%rcx				# substract 1 from counter and repeat
	jnz	LAddLoop
LAddEnd:
	ret





.globl ubigintSub
.type ubigintSub, @function
ubigintSub:

	# rop = op1 - op2
	# char ubigintSub (ubigint_t rop, ubigint_t op1, ubigint_t op2, int size);    returns borrow flag (0 or 1)
	# must preserve value of op2. op1 can be override (rop -> &op1)

	#########################################
	#
	# INPUT ARGUMENTS
	# rdi -> &rop
	# rsi -> op1
	# rdx -> op2
	# rcx -> size
	#
	#########################################	

	#########################################
	# 
	# WORK FRAME
	#
	# rdi -> rop
	# rsi -> op1
	# rdx -> op2
	# rcx -> size in quad words (also counter)
	# 
	#########################################

	
	#compute rdix = rop
	movq	(%rdi), %rdi
	

	# summation loop
	# we use %rcx as counter. Start at (size) 
	movq	$0x1, %r8			# borrow flag value

	movq	-8(%rsi, %rcx, 8), %r9		# %r9 = op1[size-1]
	movq	%r9, -8(%rdi, %rcx, 8)		# rop[size-1] = %r9
	
	movq	-8(%rdx, %rcx, 8), %r9		# %r9 = op2[size-1]
	subq	%r9, -8(%rdi, %rcx, 8)		# rop[size-1] -= %r9

	movq	$0x0, %rax
	cmovcq	%r8, %rax			# store in %rax borrow flag

	decq	%rcx
	jz	LSubEnd			
LSubLoop:
	movq	-8(%rsi, %rcx, 8), %r9		# %r9 = op1[size-1]
	movq	%r9, -8(%rdi, %rcx, 8)		# rop[size-1] = %r9
	
	movq	-8(%rdx, %rcx, 8), %r9		# %r9 = op2[size-1]
	sbbq	%r9, -8(%rdi, %rcx, 8)		# rop[size-1] -= %r9 WITH BORROW!

	movq	$0x0, %rax
	cmovcq	%r8, %rax			# store in %rax borrow flag

	decq	%rcx				# substract 1 from counter and repeat
	jnz	LSubLoop
LSubEnd:
	ret








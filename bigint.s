.text

.globl ubigintAdd
.type ubigintAdd, @function
ubigintAdd:

	# rop = op1 + op2
	# char ubigintAdd (ubigint_t *rop, ubigint_t op1, ubigint_t op2, int size);
	# returns carry flag (0 or 1)

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
	# r9  -> cumulative register for summation
	# r8  -> constant value 1
	# rax -> carry flag to return
	# 
	#########################################

	
	#compute rdix = rop
	movq	(%rdi), %rdi
	

	# summation loop
	# we use %rcx as counter. Start at (size) 
	movq	$0x1, %r8			# carry flag value

	movq	-8(%rsi, %rcx, 8), %r9		# %r9 = op1[size-1]
	
	addq	-8(%rdx, %rcx, 8), %r9		# %r9 += op2[size-1]
	movq	%r9, -8(%rdi, %rcx, 8)		# rop[size-1] = %r9

	movq	$0x0, %rax
	cmovcq	%r8, %rax			# store in %rax carry flag

	decq	%rcx
	jz	LUAddEnd			
LUAddLoop:
	movq	-8(%rsi, %rcx, 8), %r9		# %r9 = op1[size-1]
	
	adcq	-8(%rdx, %rcx, 8), %r9		# %r9 += op2[size-1]
	movq	%r9, -8(%rdi, %rcx, 8)		# rop[size-1-i] == %r9 WITH CARRY!

	movq	$0x0, %rax
	cmovcq	%r8, %rax			# store in %rax carry flag

	decq	%rcx				# substract 1 from counter and repeat
	jnz	LUAddLoop
LUAddEnd:
	ret




.globl bigintAdd
.type bigintAdd, @function
bigintAdd:

	# rop = op1 + op2
	# char bigintAdd (ubigint_t *rop, ubigint_t op1, ubigint_t op2, int size);
	# returns overflow flag (0 or 1)

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
	# r9  -> cumulative register for summation
	# r8  -> constant value 1
	# rax -> carry flag to return
	# 
	#########################################

	
	#compute rdix = rop
	movq	(%rdi), %rdi
	

	# summation loop
	# we use %rcx as counter. Start at (size) 
	movq	$0x1, %r8			# carry flag value

	movq	-8(%rsi, %rcx, 8), %r9		# %r9 = op1[size-1]
	
	addq	-8(%rdx, %rcx, 8), %r9		# %r9 += op2[size-1]
	movq	%r9, -8(%rdi, %rcx, 8)		# rop[size-1] = %r9

	movq	$0x0, %rax
	cmovoq	%r8, %rax			# store in %rax carry flag

	decq	%rcx
	jz	LAddEnd			
LAddLoop:
	movq	-8(%rsi, %rcx, 8), %r9		# %r9 = op1[size-1]
	
	adcq	-8(%rdx, %rcx, 8), %r9		# %r9 += op2[size-1]
	movq	%r9, -8(%rdi, %rcx, 8)		# rop[size-1-i] == %r9 WITH CARRY!

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
	# char ubigintSub (ubigint_t *rop, ubigint_t op1, ubigint_t op2, int size);
	# returns borrow flag (0 or 1)

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
	# r9  -> cumulative register for substraction
	# r8  -> constant value 1
	# rax -> borrow flag to return
	# 
	#########################################

	
	#compute rdi = rop
	movq	(%rdi), %rdi
	

	# summation loop
	# we use %rcx as counter. Start at (size) 
	movq	$0x1, %r8			# borrow flag value

	movq	-8(%rsi, %rcx, 8), %r9		# %r9 = op1[size-1]
	
	subq	-8(%rdx, %rcx, 8), %r9		# %r9 -= op2[size-1]
	movq	%r9, -8(%rdi, %rcx, 8)		# rop[size-1] = %r9

	movq	$0x0, %rax
	cmovcq	%r8, %rax			# store in %rax borrow flag

	decq	%rcx
	jz	LUSubEnd			
LUSubLoop:
	movq	-8(%rsi, %rcx, 8), %r9		# %r9 = op1[size-1]
	
	sbbq	-8(%rdx, %rcx, 8), %r9		# %r9 -= op2[size-1]
	movq	%r9, -8(%rdi, %rcx, 8)		# rop[size-1-i] = %r9 WITH BORROW!

	movq	$0x0, %rax
	cmovcq	%r8, %rax			# store in %rax borrow flag

	decq	%rcx				# substract 1 from counter and repeat
	jnz	LUSubLoop
LUSubEnd:
	ret







.globl bigintSub
.type bigintSub, @function
bigintSub:

	# rop = op1 - op2
	# char bigintSub (ubigint_t *rop, ubigint_t op1, ubigint_t op2, int size);
	# returns borrow flag (0 or 1)

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
	# r9  -> cumulative register for substraction
	# r8  -> constant value 1
	# rax -> borrow flag to return
	# 
	#########################################

	
	#compute rdi = rop
	movq	(%rdi), %rdi
	

	# summation loop
	# we use %rcx as counter. Start at (size) 
	movq	$0x1, %r8			# borrow flag value

	movq	-8(%rsi, %rcx, 8), %r9		# %r9 = op1[size-1]
	
	subq	-8(%rdx, %rcx, 8), %r9		# %r9 -= op2[size-1]
	movq	%r9, -8(%rdi, %rcx, 8)		# rop[size-1] = %r9

	movq	$0x0, %rax
	cmovoq	%r8, %rax			# store in %rax borrow flag

	decq	%rcx
	jz	LSubEnd			
LSubLoop:
	movq	-8(%rsi, %rcx, 8), %r9		# %r9 = op1[size-1]
	
	sbbq	-8(%rdx, %rcx, 8), %r9		# %r9 -= op2[size-1]
	movq	%r9, -8(%rdi, %rcx, 8)		# rop[size-1-i] = %r9 WITH BORROW!

	movq	$0x0, %rax
	cmovoq	%r8, %rax			# store in %rax borrow flag

	decq	%rcx				# substract 1 from counter and repeat
	jnz	LSubLoop
LSubEnd:
	ret





.globl ubigintMul
.type ubigintMul, @function
ubigintMul:
	pushq	%rbx

	# roph:ropl = op1 * op2
	# void ubigintMul (ubigint_t *roph, ubigint_t *ropl, ubigint_t op1, ubigint_t op2, int size);

	#########################################
	#
	# INPUT ARGUMENTS
	# rdi -> &roph
	# rsi -> &ropl
	# rdx -> op1
	# rcx -> op2
	# r8  -> size
	#
	#########################################	

	#########################################
	# 
	# WORK FRAME
	#
	# rdi -> roph
	# rsi -> ropl
	# r8  -> op1
	# r9  -> op2
	# rcx -> counter i
	# r10 -> counter j
	# rbx -> value k
	# r11 -> backup for size (not counter)
	# rax -> multiplier
	# rdx -> multiplier
	# 
	#########################################

	# preserve size value
	movq	%r8, %r11
	
	movq	%rdx, %r8
	movq	%rcx, %r9


	#compute rdi = roph
	movq	(%rdi), %rdi
	#compute rds = ropl
	movq	(%rsi), %rsi

	# allocate memory for partial rop variable (2*size blocks) in stack
	salq	$0x4, %r11			# r11 = 16*size bytes
	subq	%r11, %rsp			# stack allocated
	sarq	$0x4, %r11			# restore r11





	# initialize partial rop and auxiliar with 0
	movq	%r11, %rcx
	salq	$0x1, %rcx			# rcx = 2*size
LMulInitLoop:
	movq	$0x0, -8(%rsp, %rcx, 8)
	decq	%rcx
	jnz	LMulInitLoop


	movq	%r11, %rcx			# initialize first counter
LMulLoopI:
	movq	%r11, %r10			# reinitialize second counter
LMulLoopJ:
	# k = i+j+1
	movq	%rcx, %rbx
	addq	%r10, %rbx

	# perform product
	movq	-8(%r8, %rcx, 8), %rax		# rax = op1[i-1]
	movq	-8(%r9, %r10, 8), %rdx		# rdx = op2[j-1]
	mulq	%rdx				# rax:rdx = op1*op2


	addq	%rax, -8(%rsp, %rbx, 8)
	dec	%rbx
	adcq	%rdx, -8(%rsp, %rbx, 8)
	jnc	LMulSumLoopEnd
LMulSumLoop:
	dec	%rbx
	adcq	$0x0, -8(%rsp, %rbx, 8)
	jc	LMulSumLoop
LMulSumLoopEnd:
	
	# end loop j
	dec	%r10
	jnz	LMulLoopJ

	# end loop i
	dec	%rcx
	jnz	LMulLoopI




	# upload values into roph and ropl
	movq	%r11, %rcx			# rcx = size
	movq	%r11, %rbx			
	salq	$0x1, %rbx			# rbx = 2*size
LMulRopLoop:
	movq	-8(%rsp, %rcx, 8), %rax
	movq	%rax, -8(%rdi, %rcx, 8)
	movq	-8(%rsp, %rbx, 8), %rax
	movq	%rax, -8(%rsi, %rcx, 8)
	dec	%rbx
	dec	%rcx
	jnz	LMulRopLoop


	# release memory for stack
	salq	$0x4, %r11
	addq	%r11, %rsp			# stack allocated
	popq	%rbx

	ret





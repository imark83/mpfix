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






auxAdd:
	# auxiliar function to add integers of size twice the size of fix_t
	# this function is called by fixmul_int function


	ret



.globl fixmul_int
.type fixmul_int, @function
fixmul_int:

	# roph:ropl = op1 * op2
	# char fixmul_int (mp_int *rop, mp_int *op1, mp_int *op2, unsigned int size);
	# rop has 2*size blocks
	# op1 and op2 have size blocks
	# must preserve value of op2 and op1.

	#########################################
	# 
	# WORK FRAME
	#
	# rdi -> *rop
	# rsi -> *op1
	# r8  -> *op2 (initially stored in rdx)
	# rsp -> *aux data
	# rcx -> size in quad words (also counter (i))
	# r9  -> size in quad words (also counter (j))
	# r10 -> auxiliar index (k)
	# r11 -> size in quad words (backup)
	# rax -> for mul arguments
	# rdx -> for mul arguments
	# 
	#########################################
	
	# mov rdx to r8
	movq	%rdx, %r8

	# backup size value
	movq	%rcx, %r11			# r11 = size

	# allocate memory for aux (2*size blocks) in stack
	salq	$0x4, %r11			# r11 = 2*size*8 bytes
	subq	%r11, %rsp			# stack allocated
	sarq	$0x4, %r11			# restore r11


	# initialize  aux with 0
	salq	$0x1, %rcx			# rcx = 2*size
LMulIntLoop0:
	movq	$0x0, -8(%rsp, %rcx, 8)
	decq	%rcx
	jnz	LMulIntLoop0
	movq	%r11, %rcx			# restore counter %rcx




	# initialize  result with 0
LMulIntLoop1:
	movq	$0x0, -8(%rdi, %rcx, 8)
	decq	%rcx
	jnz	LMulIntLoop1
	movq	%r11, %rcx			# restore counter %rcx



LMulIntLoopI:
	movq	%r11, %r9	# reinitialize second counter
LMulIntLoopJ:
	# k = i+j+1
	movq	%rcx, %r10	
	addq	%r9, %r10
	decq	%r10		

	movq	-8(%rsi, %rcx, 8), %rax
	movq	-8(%r8, %r9, 8), %rdx
	mulq	%rdx

	movq	%rax, -8(%rsp, %r10, 8)
	movq	%rdx, -16(%rsp, %r10, 8)


	movq	$0x0, (%rsp, %r10, 8)
	movq	$0x0, -8(%rsp, %r10, 8)

	dec	%r9
	jnz	LMulIntLoopJ

	dec	%rcx
	jnz	LMulIntLoopI



LMulIntEnd:
	# free stack
	salq	$0x4, %r11			# r11 = 2*size*8 bytes
	addq	%r11, %rsp			# stack freed
	ret








	.file	"mpfix.c"
	.text
	.globl	fixinit
	.type	fixinit, @function
fixinit:
.LFB39:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	movl	%esi, (%rdi)
	movl	%edx, 4(%rdi)
	sall	$3, %esi
	movl	%esi, %edi
	call	malloc
	movq	%rax, 8(%rbx)
	cmpl	$0, (%rbx)
	je	.L1
	movl	$0, %eax
.L3:
	movslq	%eax, %rcx
	movq	8(%rbx), %rdx
	movq	$0, (%rdx,%rcx,8)
	addl	$1, %eax
	cmpl	(%rbx), %eax
	jb	.L3
.L1:
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE39:
	.size	fixinit, .-fixinit
	.globl	fixfree
	.type	fixfree, @function
fixfree:
.LFB40:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rsi, %rdi
	call	free
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE40:
	.size	fixfree, .-fixfree
	.globl	main
	.type	main, @function
main:
.LFB41:
	.cfi_startproc
	subq	$72, %rsp
	.cfi_def_cfa_offset 80

	movl	$4, %edx
	movl	$3, %esi
	leaq	16(%rsp), %rdi
	call	fixinit

	movl	$4, %edx
	movl	$3, %esi
	leaq	32(%rsp), %rdi
	call	fixinit

	movl	$4, %edx
	movl	$3, %esi
	leaq	48(%rsp), %rdi
	call	fixinit

	movq	56(%rsp), %rax
	movq	$0, (%rax)
	movq	56(%rsp), %rax
	movq	$0, 8(%rax)
	movq	56(%rsp), %rax
	movq	$1, 16(%rax)
	movq	40(%rsp), %rax
	movabsq	$-9223372036854775808, %rcx
	movq	%rcx, (%rax)
	movq	40(%rsp), %rax
	movq	$0, 8(%rax)
	movq	40(%rsp), %rdx
	movq	$0, 16(%rdx)
	movq	48(%rsp), %rcx
	movq	56(%rsp), %r8
	movq	32(%rsp), %rsi
	leaq	16(%rsp), %rdi
	call	fixsub

	movl	$2, %r8d
	movq	48(%rsp), %rdx
	movq	56(%rsp), %rcx
	leaq	16(%rsp), %rsi
	leaq	8(%rsp), %rdi
	call	fixmul_long

	movq	24(%rsp), %rdi
	call	free
	movq	40(%rsp), %rdi
	call	free
	movq	56(%rsp), %rdi
	call	free
	addq	$72, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE41:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 4.8.2-19ubuntu1) 4.8.2"
	.section	.note.GNU-stack,"",@progbits

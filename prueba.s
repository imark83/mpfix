	.file	"prueba.c"
	.text
	.globl	fpinit
	.type	fpinit, @function
fpinit:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	%edx, -32(%rbp)
	movq	-24(%rbp), %rax
	movl	-28(%rbp), %edx
	movl	%edx, (%rax)
	movq	-24(%rbp), %rax
	movl	-32(%rbp), %edx
	movl	%edx, 4(%rax)
	movl	-28(%rbp), %eax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, 8(%rax)
	movq	$0, -8(%rbp)
	jmp	.L2
.L3:
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	-8(%rbp), %rdx
	salq	$3, %rdx
	addq	%rdx, %rax
	movq	$0, (%rax)
	addq	$1, -8(%rbp)
.L2:
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, %eax
	cmpq	-8(%rbp), %rax
	jg	.L3
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	fpinit, .-fpinit
	.globl	fpfree
	.type	fpfree, @function
fpfree:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, %rdi
	call	free
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	fpfree, .-fpfree
	.globl	fpadd
	.type	fpadd, @function
fpadd:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	%rsi, %rax
	movq	%rdx, %rsi
	movq	%rsi, %rdx
	movq	%rax, -32(%rbp)
	movq	%rdx, -24(%rbp)
	movq	%rcx, %rax
	movq	%r8, %rcx
	movq	%rcx, %rdx
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	movl	$1, -32(%rbp)
	movl	$2, -48(%rbp)
	movq	-24(%rbp), %rax
	movq	$3, (%rax)
	movq	-40(%rbp), %rax
	movq	$4, (%rax)
	movq	-8(%rbp), %rax
	movl	$5, (%rax)
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	fpadd, .-fpadd
	.globl	main
	.type	main, @function
main:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6

	subq	$48, %rsp
	leaq	-48(%rbp), %rax
	movl	$40, %edx
	movl	$80, %esi
	movq	%rax, %rdi
	call	fpinit

	leaq	-32(%rbp), %rax
	movl	$40, %edx
	movl	$80, %esi
	movq	%rax, %rdi
	call	fpinit

	leaq	-16(%rbp), %rax
	movl	$40, %edx
	movl	$80, %esi
	movq	%rax, %rdi
	call	fpinit

	movq	-16(%rbp), %rcx
	movq	-8(%rbp), %rdi
	movq	-32(%rbp), %rsi
	movq	-24(%rbp), %rdx
	leaq	-48(%rbp), %rax
	movq	%rdi, %r8
	movq	%rax, %rdi
	call	fpadd

	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	fpfree
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 4.8.2-19ubuntu1) 4.8.2"
	.section	.note.GNU-stack,"",@progbits

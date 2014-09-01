	.text
	.globl _fpinit
_fpinit:
LFB4:
	pushq	%rbp
LCFI0:
	movq	%rsp, %rbp
LCFI1:
	subq	$32, %rsp
LCFI2:
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movl	%edx, -32(%rbp)
	movq	-24(%rbp), %rax
	movl	-28(%rbp), %edx
	movl	%edx, (%rax)
	movq	-24(%rbp), %rax
	movl	-32(%rbp), %edx
	movl	%edx, 4(%rax)
	mov	-28(%rbp), %eax
	movq	%rax, %rdi
	call	_malloc
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, 8(%rax)
	movq	$0, -8(%rbp)
	jmp	L2
L3:
	movq	-24(%rbp), %rax
	movq	8(%rax), %rax
	movq	-8(%rbp), %rdx
	salq	$3, %rdx
	addq	%rax, %rdx
	movq	-8(%rbp), %rax
	movq	%rax, (%rdx)
	addq	$1, -8(%rbp)
L2:
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	mov	%eax, %eax
	cmpq	-8(%rbp), %rax
	jg	L3
	leave
LCFI3:
	ret
LFE4:
	.globl _fpfree
_fpfree:
LFB5:
	pushq	%rbp
LCFI4:
	movq	%rsp, %rbp
LCFI5:
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, -28(%rbp)
	movl	$-942797699, %edx
	movl	-28(%rbp), %eax
	mull	%edx
	movl	%edx, %eax
	shrl	$5, %eax
	mov	%eax, %eax
	movq	%rax, -8(%rbp)
	movq	-24(%rbp), %rax
	movl	(%rax), %ecx
	movl	$-942797699, %edx
	movl	%ecx, %eax
	mull	%edx
	shrl	$5, %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%edx, %eax
	movl	%ecx, %edx
	subl	%eax, %edx
	mov	%edx, %edx
	movq	%rdx, -16(%rbp)
	popq	%rbp
LCFI6:
	ret
LFE5:
	.globl _main
_main:
LFB6:
	pushq	%rbp
LCFI7:
	movq	%rsp, %rbp
LCFI8:
	subq	$48, %rsp
LCFI9:
	leaq	-16(%rbp), %rax
	movl	$40, %edx
	movl	$80, %esi
	movq	%rax, %rdi
	call	_fpinit
	leaq	-32(%rbp), %rax
	movl	$40, %edx
	movl	$80, %esi
	movq	%rax, %rdi
	call	_fpinit
	leaq	-48(%rbp), %rax
	movl	$40, %edx
	movl	$80, %esi
	movq	%rax, %rdi
	call	_fpinit
	movq	-48(%rbp), %rcx
	movq	-40(%rbp), %rdi
	movq	-32(%rbp), %rsi
	movq	-24(%rbp), %rdx
	leaq	-16(%rbp), %rax
	movq	%rdi, %r8
	movq	%rax, %rdi
	call	_fpadd
	leaq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	_fpfree
	leave
LCFI10:
	ret
LFE6:
	.section __TEXT,__eh_frame,coalesced,no_toc+strip_static_syms+live_support
EH_frame1:
	.set L$set$0,LECIE1-LSCIE1
	.long L$set$0
LSCIE1:
	.long	0
	.byte	0x1
	.ascii "zR\0"
	.byte	0x1
	.byte	0x78
	.byte	0x10
	.byte	0x1
	.byte	0x10
	.byte	0xc
	.byte	0x7
	.byte	0x8
	.byte	0x90
	.byte	0x1
	.align 3
LECIE1:
LSFDE1:
	.set L$set$1,LEFDE1-LASFDE1
	.long L$set$1
LASFDE1:
	.long	LASFDE1-EH_frame1
	.quad	LFB4-.
	.set L$set$2,LFE4-LFB4
	.quad L$set$2
	.byte	0
	.byte	0x4
	.set L$set$3,LCFI0-LFB4
	.long L$set$3
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$4,LCFI1-LCFI0
	.long L$set$4
	.byte	0xd
	.byte	0x6
	.byte	0x4
	.set L$set$5,LCFI3-LCFI1
	.long L$set$5
	.byte	0xc
	.byte	0x7
	.byte	0x8
	.align 3
LEFDE1:
LSFDE3:
	.set L$set$6,LEFDE3-LASFDE3
	.long L$set$6
LASFDE3:
	.long	LASFDE3-EH_frame1
	.quad	LFB5-.
	.set L$set$7,LFE5-LFB5
	.quad L$set$7
	.byte	0
	.byte	0x4
	.set L$set$8,LCFI4-LFB5
	.long L$set$8
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$9,LCFI5-LCFI4
	.long L$set$9
	.byte	0xd
	.byte	0x6
	.byte	0x4
	.set L$set$10,LCFI6-LCFI5
	.long L$set$10
	.byte	0xc
	.byte	0x7
	.byte	0x8
	.align 3
LEFDE3:
LSFDE5:
	.set L$set$11,LEFDE5-LASFDE5
	.long L$set$11
LASFDE5:
	.long	LASFDE5-EH_frame1
	.quad	LFB6-.
	.set L$set$12,LFE6-LFB6
	.quad L$set$12
	.byte	0
	.byte	0x4
	.set L$set$13,LCFI7-LFB6
	.long L$set$13
	.byte	0xe
	.byte	0x10
	.byte	0x86
	.byte	0x2
	.byte	0x4
	.set L$set$14,LCFI8-LCFI7
	.long L$set$14
	.byte	0xd
	.byte	0x6
	.byte	0x4
	.set L$set$15,LCFI10-LCFI8
	.long L$set$15
	.byte	0xc
	.byte	0x7
	.byte	0x8
	.align 3
LEFDE5:
	.subsections_via_symbols

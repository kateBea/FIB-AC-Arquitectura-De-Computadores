 .text
	.align 4
	.globl Asignar
	.type Asignar,@function
Asignar:
	pushl   %ebp			# Configurar nuevo stack frame, guardo antigua base pointer
	movl    %esp, %ebp       # Seteo el nuevo base pointer

	# Calculo dirección de v[pos] como @v + pos * sizeof(S1)
	movl    24(%ebp), %eax   # %eax = pos
	imull   $12, %eax        # %eax = pos * sizeof(S1)
	addl    8(%ebp), %eax    # %eax = &v[pos]

	movb    12(%ebp), %dl    # %dl = X.c
	movb    %dl, 0(%eax)     # v[pos].c = X.c

	movl    16(%ebp), %edx   # %edx = X.k
	movl    %edx, 4(%eax)    # v[pos].k = X.k

	movl    20(%ebp), %edx   # %edx = X.m
	movl    %edx, 8(%eax)    # v[pos].m = X.m

	popl    %ebp
	ret
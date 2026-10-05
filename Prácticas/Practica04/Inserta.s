 .text
	.align 4
	.globl Insertar
	.type Insertar,@function
Insertar:
	Insertar:
    pushl %ebp
    movl  %esp, %ebp
    subl  $12, %esp         # i=-4, j=-8, lug=-12

    movl  $0, -4(%ebp)       # i <- 0
    movl  $-1, -12(%ebp)         # lug <- -1

do_loop:
    movl  -4(%ebp), %ecx       # %ecx <- i
    imull $12, %ecx              # %ecx <- i * sizeof(S1)
    addl  8(%ebp), %ecx          # %ecx <- &v[i]

    movl  16(%ebp), %eax         # %eax <- X.k
    cmpl  4(%ecx), %eax          # comparar X.k con v[i].k
    jl    found_lug               # if (X.k < v[i].k)

    addl  $1, -4(%ebp)           # i++

    movl  -4(%ebp), %ecx
    imull $12, %ecx
    addl  8(%ebp), %ecx          # %ecx <- &v[i]

    cmpl  $0x80000000, 4(%ecx)   # v[i].k != centinela ?
    jne   do_loop
    jmp   after_do

found_lug:
    movl  -4(%ebp), %eax
    movl  %eax, -12(%ebp)        # lug <- i

after_do:
    # if (v[i].k == 0x80000000)
    #     lug = i;

    movl  -4(%ebp), %ecx
    imull $12, %ecx
    addl  8(%ebp), %ecx

    cmpl  $0x80000000, 4(%ecx)
    jne   scan_end_test

    movl  -4(%ebp), %eax
    movl  %eax, -12(%ebp)   # lug <- i
    jmp   shift_init

scan_end_body:
    addl  $1, -4(%ebp)       # i++

scan_end_test:
    movl  -4(%ebp), %ecx
    imull $12, %ecx
    addl  8(%ebp), %ecx

    cmpl  $0x80000000, 4(%ecx)
    jne   scan_end_body

shift_init:
    movl  -4(%ebp), %eax
    movl  %eax, -8(%ebp)     # j <- i
    jmp   shift_test

shift_body:
    # %ecx <- &v[j]
    movl  -8(%ebp), %ecx
    imull $12, %ecx
    addl  8(%ebp), %ecx

    # %edx <- &v[j+1]
    movl  -8(%ebp), %edx
    addl  $1, %edx
    imull $12, %edx
    addl  8(%ebp), %edx

    movb  0(%ecx), %al   # v[j+1].c <- v[j].c
    movb  %al, 0(%edx)

    movl  4(%ecx), %eax  # v[j+1].k <- v[j].k
    movl  %eax, 4(%edx)

    movl  8(%ecx), %eax  # v[j+1].m <- v[j].m
    movl  %eax, 8(%edx)

    subl  $1, -8(%ebp)    # j--

shift_test:
    movl  -8(%ebp), %eax
    cmpl  -12(%ebp), %eax    # j >= lug ?
    jge   shift_body

    # Asignar(v, X, lug)
    pushl -12(%ebp)          # pos = lug
    pushl 20(%ebp)           # X.m
    pushl 16(%ebp)           # X.k
    pushl 12(%ebp)           # X.c + padding
    pushl 8(%ebp)            # v

    call  Asignar
    addl  $20, %esp

    movl  -4(%ebp), %eax   # return i + 1
    addl  $1, %eax

    movl  %ebp, %esp
    popl  %ebp
    ret

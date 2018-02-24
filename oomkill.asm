;WORK IN PROGRESS
section .data

s dq 0
ns dq 100000000 ;100ms


section .text

global _start
 _start:

	;SEEDER CODE

	;fork
	mov rax, 57
	syscall	
	test rax,rax
	jz go

	;nanosleep
	mov rax, 35
	mov rdi, s
	xor rsi, rsi
	syscall

	jmp _start
	go:

    ;GROWER CODE init

    ;brk
    mov rax, 12
    xor rdi, rdi
    syscall

    mov rbx, rax ; get current state
    mov r12, 1024*1024 ;1M

    grow:
    ;GROWER CODE

    ;brk
    mov rax, 12
    lea rdi, [rbx+r12]
    syscall

    ;fork
    mov rax, 57
    syscall
    test rax, rax
    jnz grow

    ;dirty pages
    mov rcx, r12
    shr rcx, 10 ; /1024 ergo how manny kb
    lop:
    mov rax, rcx
    shl rax, 10 ;rax = rcx*1024
    mov byte [rbx+rax], 0
    loop lop
    ;TODO

    ;double page size
    shl r12, 1
    jmp grow

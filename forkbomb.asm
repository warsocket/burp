section .data

s dq 0
ns dq 500000000


section .text

global _start
_start:

	;fork
	mov rax, 57
	syscall	
	test rax, rax
	jz fork

	;nanosleep
	mov rax, 35
	mov rdi, s
	xor rsi, rsi
	syscall

	;exit
	mov rax, 60
	xor rdi, rdi
	syscall

	fork:
	;fork
	mov rax, 57
	syscall	
	jmp fork

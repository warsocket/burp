;WORK IN PROGRESS
section .data

s dq 0
ns dq 100000000 ;100ms


section .text

global _start
_start:

	;todo brk here ad dirty pages

	;fork
	mov rax, 57
	syscall	
	text rax,rax
	jz go

	;nanosleep
	mov rax, 35
	mov rdi, s
	xor rsi, rsi
	syscall

	jmp _start
	go:


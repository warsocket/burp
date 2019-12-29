section .data
	char dw '01'
	file times 64 db 0,0

section .text

global _start
_start:
	;callee saved registers
	mov rbx, file
	mov r15, char
	xor r12, r12
	mov r12, 1

	write:
	;write file name (bits form r12)
	mov rcx, 64
	mov r9, r12
	loopy:
	xor rax, rax
	rcr r9, 1
	rcl rax, 1
	mov dl, byte [r15+rax]
	mov byte[rbx+rcx-1], dl
	loop loopy

	;sys_open
	mov rax, 2
	mov rdi, file
	mov rsi, 0x0040
	xor rdx, rdx ;0000 rights
	syscall	

	;sys_close
	mov rdi, rax
	mov rax, 3
	syscall

	inc r12
	jmp write

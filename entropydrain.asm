section .bss
dump resb 1


global _start
section .text
_start:

;fork x3 meaning 8 prcoesses
mov rax, 57
syscall

mov rax, 57
syscall

mov rax, 57
syscall

getrandom:
;getrandom
mov rax, 318
mov rdi, dump
mov rsi, 1
mov rdx, 2
syscall

jmp getrandom
; main.asm - minimal x86-64 Linux program (NASM syntax)

%include "main.inc"

section .rodata
    msg:    db  "Running...", 10
    msglen: equ $ - msg

section .text

global _start

_start:
    ; write(1, msg, msglen)
    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    mov     rsi, msg
    mov     rdx, msglen
    syscall

    ; exit(0)
    mov     rax, SYS_EXIT
    xor     rdi, rdi
    syscall

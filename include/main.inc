; main.inc - syscall + fd constants for x86-64 Linux

%ifndef MAIN_INC
%define MAIN_INC

SYS_WRITE   equ 1
SYS_EXIT    equ 60

STDOUT      equ 1
STDERR      equ 2

%endif ; MAIN_INC

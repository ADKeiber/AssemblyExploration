global _start

section .text
_start:
   mov ecx, 199  ;set ecx to 199
   mov ebx, 42  ;sets exit status to 42. Ebx determines exit code when finished
   mov eax, 1   ;sys_exit system call
   cmp ecx, 100 ;compare ecx to 100
   jl skip     ;jump to the "skip" label if less than
   mov ebx, 13  ; sets exit status to 13
skip:
   int 0x80

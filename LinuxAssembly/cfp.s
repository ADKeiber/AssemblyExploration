section .data
   x DD 3.14
   y DD 2.1

section .text
global _start 

_start:
   MOVSS xmm0, [x]
   MOVSS xmm1, [y]
   UCOMISS xmm0, xmm1 ; NOTE: This is used to compare 2 floating points and sets some eflags
   JA greater
   JMP end

greater:
   MOV ecx, 1

end:
   MOV eax, 1

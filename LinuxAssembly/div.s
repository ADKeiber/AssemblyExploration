section .text
global _start

_start:
   MOV eax, 11
   MOV ecx, 2
   DIV ecx              ;remainder is stored in edx
   INT 80h

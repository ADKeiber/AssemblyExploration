section .text

global _start

_start:
   mov eax, 0b1010
   MOV ebx, 0b1100
   XOR eax, ebx
   int 80h


section .text

global _start

_start:
   mov eax, 0b1010
   mov ebx, 0b1100
   AND eax, ebx

   mov eax, 0b1010
   mov ebx, 0b1100
   OR  eax, ebx
   NOT eax
   int 80h

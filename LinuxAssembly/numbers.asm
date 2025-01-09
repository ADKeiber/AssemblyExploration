section .text
   global _start

_start:
   mov   eax, '3'
   sub   eax, '0'

   mov   ebx, '4'
   sub   ebx, '0'
   add   eax, ebx
   add   eax, '0'

   mov   [sum], eax
   mov   ecx, msg
   mov   edx, len
   mov   ebx, 1      ; stdout
   mov   eax, 4      ; sys_write
   int   0x80        ; kernel call

   mov   ecx, sum
   mov   edx, 1
   mov   ebx, 1      ; stdout
   mov   eax, 4      ; sys_write
   int   0x80

   mov   eax, 1      ; sys_exit
   int   0x80        ; kernel call

section .data
   msg db "The sum is:", 0xA, 0xD
   len equ $ - msg

segment .bss
   sum resb 1

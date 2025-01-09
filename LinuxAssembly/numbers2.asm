section .text
   global _start

_start:
   sub   ah, ah
   mov   al, '9'
   sub   al, '3'
   aas
   or    al, 30h
   mov   [res], ax

   mov   edx, len
   mov   ecx, msg
   mov   ebx, 1
   mov   eax, 4
   int   0x80

   mov   edx, 1      ; message length
   mov   ecx, res    ; meesage to write
   mov   ebx, 1      ; std out
   mov   eax, 4      ; sys_write
   int   0x80

   mov   eax, 1      ; sys_exit
   int   0x80

section .data
   msg db 'The Result is:', 0xa
   len equ $ - msg
section .bss
   res resb 1


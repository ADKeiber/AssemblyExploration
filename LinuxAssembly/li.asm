section .text
   global _start

_start:
   mov   ax, 9h         ; set ax to 8
   and   ax, 1          ; and ax with 1
   jz    even  
   mov   eax, 4         ; system call sys_write
   mov   ebx, 1         ; std out
   mov   ecx, odd_msg   ; message to write
   mov   edx, len2      ; length of message
   int   0x80           ; kernel call
   jmp   outprog

even:
   mov   ah, 09h
   mov   eax, 4         ; sys_write
   mov   ebx, 1         ; std out
   mov   ecx, even_msg  ; message to write
   mov   edx, len1      ;length of message
   int   0x80

outprog:
   mov   eax, 1         ; sys_exit
   int   0x80

section .data
   even_msg db 'Even Number!'    ;Even message
   len1 equ $ - even_msg

   odd_msg db 'Odd Number!'      ; Odd message
   len2 equ $ - odd_msg


section .text
   global _start

_start:
   mov   esi, 4         ; points to rightmost digit
   mov   ecx, 4         ; num of digits
   clc                  ; clears the carry flag

add_loop:
   mov   al, [num1 + esi]
   adc   al, [num2 + esi]     ; adc is the 'Add with Carry' instruction
   aaa                        ; 'ASCII Adjust after addition' instruction
   pushf                      ; 'Push Flag Register onto stack' 
   or    al, 30h
   popf                       ; 'Pop flag register from stack'

   mov   [sum + esi], al
   dec   esi
   loop  add_loop

   mov   edx, len                ; message length
   mov   ecx, msg                ; message to write
   mov   ebx, 1                  ; stdout
   mov   eax, 4                  ; sys_write
   int   0x80

   mov   edx, 5                  ; msg length
   mov   ecx, sum                ; msg to write
   mov   ebx, 1                  ; stdout
   mov   eax, 4                  ; sys_write
   int   0x80                    ; kernel call

   mov   eax, 1                  ; sys_write
   int   0x80

section .data
   msg db 'The Sum is:', 0xa
   len equ $ - msg
   num1 db '12345'
   num2 db '23456'
   sum db '     '


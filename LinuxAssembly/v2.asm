section .data
   stars times 9 db '*'

section .text
   global _start        ; must be declared for linker (ld)

_start:
   mov edx, 9           ; msg length
   mov ecx, stars       ; message to write
   mov ebx, 1           ; file descriptor (stdout)
   mov eax, 4           ; system call number (sys_write)
   int 0x80             ; call kernel

   mov eax, 1           ; system call number (sys_exit)
   int 0x80

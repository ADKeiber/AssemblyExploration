section .data
   choice DB 'y'

section .text
   global _start        ; must be declared for linker (gcc)

_start:
   mov edx, 1           ; tell linker entry point
   mov ecx, choice      ; message to write
   mov ebx, 1           ; file descriptor (stdout)
   mov eax, 4           ; system call number (sys_write)
   int 0x80             ; call kernel

   mov eax, 1           ; system call number (sys_exit)
   int 0x80

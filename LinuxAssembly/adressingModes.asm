section .data
   name db 'Aust Keiber'

section .text
   global _start

_start:
   ; Writing the name 'Austin Keiber'
   mov edx, 11       ; message length
   mov ecx, name     ; message to write
   mov ebx, 1        ; file desciprtion (stdout)
   mov eax, 4        ; system call sys_write
   int 0x80          ; could use 80h as well (kernel call)

   mov [name], dword 'Dani'    ; changed the name to Daniel Keiber

   ;writing the name 'Daniel Keiber'

   mov edx, 11    ;message length
   mov ecx, name  ; message to write
   mov ebx, 1     ; fiel descriptor (stdout)
   mov eax, 4     ; system call sys_write
   int 0x80       ; call kernel

   mov eax, 1     ; system call sys_exit
   int 0x80

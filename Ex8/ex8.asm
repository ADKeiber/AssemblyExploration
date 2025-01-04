global _start

_start:
   call func
   mov eax, 1
   mov ebx, 0
   int 0x80

func:
   ;prologue
   push ebp
   mov ebp, esp ; copies top of stack to ebp
   sub esp, 2 ; allocates 2 bytes on top of the stack

   mov [esp], byte 'H' ; puts H byte at the first byte
   mov [esp+1], byte 'i' ;puts i at the second byte added
   mov eax, 4 ; sys_write syatem call
   mov ebx, 1 ; stdout file descriptor
   mov ecx, esp ; bytes to write
   mov edx, 2   ;number of bytes to write
   int 0x80
   ; epilogue
   mov esp, ebp
   pop ebp
   ret ; return to the top of the stack (esp)

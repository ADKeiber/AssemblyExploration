global _start

_start:
   call func
   mov eax, 1
   int 0x80

func:
   mov ebx, 42
   ;pop eax
   ;jmp eax
   ret ; the 2 lines above do the same as ret
   

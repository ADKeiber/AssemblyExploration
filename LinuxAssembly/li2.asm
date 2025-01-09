section .text
   global _start

_start:
   mov   al, 5          ; setting 5 in the al
   mov   bl, 3          ; setting 3 in the bl register
   or    al, bl         ; or bitwise operator on al and bl register result should be (0101 OR 0011) result = (0111) or 7 
   add   al, byte '0'   ; converting decimal to ascii
   
   mov   [result], al
   mov   eax, 4
   mov   ebx, 1
   mov   ecx, result
   mov   edx, 1
   int   0x80

outprog:
   mov   eax, 1      ; sys_exit call
   int   0x80        ; kernel call

section .bss
   result resb 1


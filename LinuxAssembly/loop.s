section .data
   list DB 1,2,3,4

section .text
global _start

_start:
   MOV eax, 0     ;loop counter
   mov cl, 0      ;sum

loop:
   MOV bl, [list + eax]
   ADD cl, bl ; retrieved
   INC eax
   CMP eax, 4 ; since we know the length is 4 we use that here but we could also use an expected null terminator value to determine if we should loop
   JE end
   JMP loop

end:
   MOV eax, 1
   MOV ecx, 1
   INT 80h

section .data

section .text

global _start

_start:
   MOV eax, 1 
   MOV ebx, 2
   CMP eax, ebx ; Subtracts the 2 registers. Discards result. Uses result to set eflag register
   JL lesser   ; NOTE: the code would still execute the lesser function because all code under _start is executed. We need to skip over that part of the code with JMP end
   JMP end

lesser:
   MOV ecx,1

end:
   INT 80h

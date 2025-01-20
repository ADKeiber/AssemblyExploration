section .data

section .text
global main

addTwo:
   ; stack setup
   PUSH ebp       ;EBP is used as a sort of divider in the stack to tell what belongs to certain methods
   MOV ebp, esp

   ;actual method
   MOV eax, [ebp + 8]
   MOV ebx, [ebp + 12]
   ADD eax, ebx

   ;stack cleanup
   POP ebp

   RET

main:
   PUSH 4
   PUSH 1

   CALL addTwo
   MOV ebx, eax
   MOV eax, 1
   INT 80h

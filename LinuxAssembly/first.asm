section .data ;stores variables

section .text ; actual code of the program
global _start

_start: ; entry point for the application. code that is executed when program is ran
   MOV eax, 1
   MOV ebx, 1  ; moves value '1' into register ebx
   INT 80h     ; runs an interrupt and tells the operating system to do something. The OS does an operation based on value in EAX (1 is exit system) ebx has the status code



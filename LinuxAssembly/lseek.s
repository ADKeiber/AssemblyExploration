section .data
   pathName DD "/home/austinkeiber/Documents/Assembly/AssemblyExploration/test.txt"
   
section .bss
   buffer: resb 10

section .text
global main

main:
   MOV eax, 5
   MOV ebx, pathName
   MOV ecx, 0
   INT 80h

   MOV ebx, eax
   MOV eax, 19 ;System call number for LSEEK
   MOV ecx, 20 ;offset of bytes
   MOV edx, 0  ;seeks from beginning NOTE: 0 is an enum equivalent to represent the start of the file
   INT 80h

   MOV eax, 3
   MOV ecx, buffer
   MOV edx, 10
   INT 80h

   MOV eax, 1
   MOV ebx, 0
   INT 80h

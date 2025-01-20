section .data
      pathName DD "/home/austinkeiber/Documents/Assembly/AssemblyExploration/LinuxAssembly/example.txt"

section .bss
   buffer: resb 1024

section .text
global main

main:
   MOV eax, 5        ; Sets the linux system call to read a file (5)
   MOV ebx, pathName ; SETS the path of the file to be read
   MOV ecx, 0        ;Read only flag added 
   INT 80h
   
   MOV ebx, eax
   MOV eax, 3

   MOV ecx, buffer
   MOV edx, 1024
   INT 80h

   MOV eax, 1
   MOV ebx, 0
   INT 80h

section .data
   pathName DD "/home/austinkeiber/Documents/Assembly/AssemblyExploration/LinuxAssembly/test.txt"
   toWrite DD "Hello World!", 0AH, 0DH, "$" ; End stuff is new line character
section .text
global main

main:
   MOV eax, 5        ;creating a file
   MOV ebx, pathName ;name of the file
   MOV ecx, 101o     ; permissions
   MOV edx, 700o     ; permissions 
   INT 80h
   
   ; Write data into a file
   MOV ebx, eax
   MOV eax, 4
   MOV ecx, toWrite
   MOV edx, 15 
   INT 80h

   MOV eax, 1
   MOV ebx, 0
   INT 80h

section .data
   num DD 5 ;doubleword 4 bytes (32 bits) of data with value of 5

section .text
global _start

_start:
   MOV eax, 1
   MOV ebx, [num] ; square brackets tell the assembler to go to the address get the value stored and move it into the register. WIthout brackets it takes the memory location not value
   INT 80h

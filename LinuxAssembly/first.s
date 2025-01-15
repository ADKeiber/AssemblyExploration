section .data

section .text
global _start

_start:
   MOV al, 0b11111111
   MOV bl, 0b0001      ;Notation is for binary 
   ADD al, bl 
   ADC ah, 0         ; adds the carry bit to ah so the add function above contains the carry information now
   INT 80h

section .text
global _start

_start:
   MOV eax, 2
   SHL eax, 1  ; shifts bits left 1. NOTE: This multiplies eax by 2
   INT 80h

section .text
global _start

_start:
   MOV eax, 2
   SHR eax, 1      ; last vaule goes into the carry register. note this shifting halves the value of whatever is being shifted.
   INT 80h

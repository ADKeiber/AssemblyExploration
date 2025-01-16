section .text
global _start

_start:
   MOV al, 0xFF 
   MOV bl, 2
   IMUL bl      ; NOTE A reigster is the accumlator and is what bl will be multipled with 
   INT 80h

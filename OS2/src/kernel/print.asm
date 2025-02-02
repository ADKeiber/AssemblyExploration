BITS 16

section _TEXT class=CODE

global _x86_Video_WriteCharTeletype ;exports function so other files can use the function

_x86_Video_WriteCharTeletype:
    PUSH bp 
    MOV bp, sp

    PUSH bx

    MOV ah, 0E0h
    MOV al, [bp+4]
    MOV bh, [bp+6]

    INT 10h

    POP bx
    MOV sp, bp

    POP bp

    RET
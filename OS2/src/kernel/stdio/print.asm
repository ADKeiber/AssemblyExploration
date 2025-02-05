BITS 16

section _TEXT class=CODE

global _x86_div64_32
_x86_div64_32:
    ; this does long division 
    PUSH bp
    MOV bp, sp

    PUSH bx

    MOV eax, [bp + 8] ;upper 32 bits
    MOV ecx, [bp + 12];Divisor
    ; NOTE that above we are passing in a 64 bit number in and eax now stores just the upper 32 bits whereas
    ; ecx stores the entire divisor because it is only allowed to be  32 bits with type uint32_t
    XOR edx, edx
    DIV ecx

    MOV bx, [bp+16] ; upper 32 bits of quotient
    MOV [bx + 4], eax

    MOV eax, [bp+4]     ; lower 32 bits of the dividend
    DIV ecx

    MOV [bx], eax
    MOV bx, [bp+18] 
    MOV [bx], edx

    POP bx
    MOV sp, bp
    POP bp
    RET

global _x86_Video_WriteCharTeletype
_x86_Video_WriteCharTeletype:
    PUSH bp
    MOV bp, sp

    PUSH bx

    MOV ah, 0Eh
    MOV al, [bp+4]
    MOV bh, [bp+6]

    INT 10h

    POP bx
    MOV sp, bp

    POP bp

    RET
BITS 16

section _TEXT class=CODE

global _x86_Disk_Reset
_x86_Disk_Reset:
    PUSH bp
    MOV bp, sp

    MOV ah, 0 ; indicated disk reset
    MOV dl, [bp+4] ;location of first parameter
    STC

    INT 13h ; resets disk
    JC reset_error

    MOV cx, 0
    MOV bx, [bp+6]
    MOV [bx], cx
    JMP end_reset

reset_error:
    MOV bx, [bp+6]
    MOV cx, 1 ; 1 indicates that there is an error
    MOV [bx], cx

end_reset:
    MOV sp, bp
    POP bp
    ret
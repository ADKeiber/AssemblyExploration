ORG 0x7c00 	; This is where the cpu looks to start the bootloader
BITS 16		; The bit amount of the OS. MOST os bootloaders are 16 bits for backwords compatibility but then evolve later to be x86 or 64 bit

main:
   MOV ax, 0
   MOV ds, ax  ; DS keeps track of the data segment
   MOV es, ax  ; Sets the start point for the extra register
   MOV ss, ax  ; Sets the start address of the stop
   ; All are init to 0

   MOV sp, 0x7C00 ; Stets the stack to the starting point of the application so we can 'grow' the stack downwards
   MOV si, os_boot_msg
   CALL print
   
   HTL

halt:
   JMP halt

print:
   PUSH si
   PUSH ax
   PUSH bx

print_loop:
   LODSB    ; loads a single byte loaded in si
   OR al, al
   JZ done_print

   MOV ah, 0x0E	  ;BIOS interrupt setup
   MOV bh, 0	  ; page number arg. Used for multiple monitors to access different pages of memory
   INT 0x10	  ; Video interupt. looks at AH 0x0e tells it to look at a character

   JMP print_loop

done_print:
   POP bx
   POP ax
   POP si
   RET

os_boot_msg: DB 'Our OS has booted!', 0x0D, 0x0A, 0 ; new line character and sentinel value

TIMES 510-($-$$) DB 0 ; '$-$$' gives the the size of the application
DW 0AA55h


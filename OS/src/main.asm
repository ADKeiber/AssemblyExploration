ORG 0x7c00 	; This is where the cpu looks to start the bootloader
BITS 16		; The bit amount of the OS. MOST os bootloaders are 16 bits for backwords compatibility but then evolve later to be x86 or 64 bit

main:
   HTL

halt:
   JMP halt

TIMES 510-($-$$) DB 0 ; '$-$$' gives the the size of the application
DW 0AA55h


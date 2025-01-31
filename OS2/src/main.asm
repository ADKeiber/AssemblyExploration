ORG 0x7C00  ; ORG tells the compiler to load Everything relative to 0x7C00. 0x7C00 is the address that the BIOS loads everything... So setting this here allows the program to properly access bios data
BITS 16     ; Most processors start in 16 bit mode (for backwards compatibility) after initial setup it usually transforms into 32 or 64 bit respectively

main:
    HTL     ; Pauses the CPU until a certain interrupt that occurs on the system

halt:
    JMP halt


TIMES 510-($-$$) DB 0    ; '$-$$' gives us the current size of the application and how many bytes it takes up. 
;510 is the location in memory we want to create data for. So esentially after the application is loaded and up till 510 bytes there will be empty data
DW 0AA55h   ; The bios is searching for this signature it is considered the signature of a valid boot record
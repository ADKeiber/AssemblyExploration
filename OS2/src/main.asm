ORG 0x7C00  ; ORG tells the compiler to load Everything relative to 0x7C00. 0x7C00 is the address that the BIOS loads everything... So setting this here allows the program to properly access bios data
BITS 16     ; Most processors start in 16 bit mode (for backwards compatibility) after initial setup it usually transforms into 32 or 64 bit respectively

main:
    MOV ax, 0
    MOV ds, ax  ; DS holds the start address for the data segment
    MOV es, ax  ; es holds the start address for the extra segment
    MOV ss, ax  ; ss hold the start address for the stop? stock?
    ; resets registers for bootloader

    MOV sp, 0x7C00 ;sets the stack bottom to be after our application code (0x7C00) so we can grow downwards!
    MOV si, os_boot_msg ; moves the os boot message address into the si register
    CALL print
    HTL     ; Pauses the CPU until a certain interrupt that occurs on the system

halt:
    JMP halt

print:
    ;Perserve values
    PUSH si
    PUSH ax
    PUSH bx

;Loads string character by character and prints to screen
print_loop:
    LODSB   ; loads single byte from si and places it inside of AL

    OR al, al       ; this will set flags... One of which will indicate if al is 0
    JZ done_print   ; checks al and if its zero (JZ) then it will jump to done_print

    MOV ah, 0x0E ; 0x0E is a BIOS interrupt for printing a character to the screen
    MOV bh, 0    ; page number as an arguement. Basically allows you to access different monitors if desired and print to them
    INT 0x10     ; video interupt. Looks at ah for what it should do. In this instance it is telling it to print a character. (it prints AL)

    JMP print_loop  ; keeps looping until al == 0 (sentinel value)

done_print:
    ; Restores the stack before print call
    POP bx
    POP ax
    POP si
    RET

os_boot_msg: DB 'Our OS has booted!', 0x0D, 0x0A, 0 ; boot message with new line characters '0' is a sentinel value dictating to the program that the string is over

TIMES 510-($-$$) DB 0    ; '$-$$' gives us the current size of the application and how many bytes it takes up. 
;510 is the location in memory we want to create data for. So esentially after the application is loaded and up till 510 bytes there will be empty data
DW 0AA55h   ; The bios is searching for this signature it is considered the signature of a valid boot record
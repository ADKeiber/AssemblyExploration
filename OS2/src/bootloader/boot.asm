ORG 0x7C00  ; ORG tells the compiler to load Everything relative to 0x7C00. 0x7C00 is the address that the BIOS loads everything... So setting this here allows the program to properly access bios data
BITS 16     ; Most processors start in 16 bit mode (for backwards compatibility) after initial setup it usually transforms into 32 or 64 bit respectively

;Header of the disk
JMP SHORT main ;Jump to start of bootloader code. NOTE: SHORT JMP mean jumping to something locally inside of this file
NOP ; NO operation... just a seperator isn't needed but is convention             

; Header data declaration
bdb_oem:                    DB 'MSWIN4.1'   ;
bdb_bytes_per_sector:       DW 512          ; Number of bytes per sector for floppy its 512 (thats what we have been using)
bdb_sectors_per_cluster:    DB 1
bdb_reserved_sectors:       DW 1 
bdb_fat_count:              DB 2            ; How many file allocation files there are on the disk for floppy we use 2
bdb_dir_entries_count:      DW 0E0h         ; the number of directory enteries on a disk
bdb_total_sectors:          DW 2880         ; 2880 x 512 = 1.33 mb floppy disk
bdb_media_descriptor_type:  DB 0F0h         ; specific value for a media type. In this instance its a floppy disk (0F0h) is used
bdb_sectors_per_fat:        DW 9            ; Secotrs per file allocation table. For floppy disk its usually set to 9
bdb_sectors_per_track:      DW 18    
bdb_heads:                  DW 2
bdb_hidden_sectors:         DD 0
bdb_large_sector_count:     DD 0

; Information about the disk (part of the header still)
ebr_drive_number:           DB 0
                            DB 0
ebr_signature:              DB 29h
ebr_volume_id:              DB 12h,34h,56h,78h
ebr_volume_label:           DB 'JAZZ OS    '    ; needs to be 11 bytes in size. Add spaces if needed
ebr_system_id:              DB 'Fat12   '       ; needs to be 8 bytes in size.

main:
    MOV ax, 0
    MOV ds, ax  ; DS holds the start address for the data segment
    MOV es, ax  ; es holds the start address for the extra segment
    MOV ss, ax  ; ss hold the start address for the stop? stock?
    ; resets registers for bootloader

    MOV sp, 0x7C00 ;sets the stack bottom to be after our application code (0x7C00) so we can grow downwards!

    ; Performing/setting up call for read disk sectors here https://stanislavs.org/helppc/int_13-2.html
    MOV [ebr_drive_number], dl  ; Moves value dl into address of EBR_drive_number
    MOV ax, 1                   ; LBA index converting to CHS
    MOV cl, 1                   ; Sector number
    MOV bx, 0x7E00              ; Location of a buffer that we KNOW exists
    call disk_read


    MOV si, os_boot_msg ; moves the os boot message address into the si register
    CALL print
    hlt     ; Pauses the CPU until a certain interrupt that occurs on the system

halt:
    JMP halt

; Converts LBA to CHS. 
; Input is LBA index in ax.
; Outputs: 
; cx [bits 0 - 5]: sector number 
; output cx [bits 6 - 15] cylinder  
; dh: head
lba_to_chs:

    ; Using these registers here.. Perserving data
    PUSH ax
    PUSH dx

    XOR dx, dx ; Zeroing out dx

    ; (LBA % sectors per track) + 1 <- sector
    DIV word [bdb_sectors_per_track] 
    INC dx      ; Sector
    mov cx, dx

    XOR dx, dx  ; clear dx (its now stored in cx)

    ; Head: (LBA / sectors per track) % number of heads. (LBA / sectors per track) IS STORED IN THE AX REGISTER RIGHT NOW!!!
    DIV word [bdb_heads]
    MOV dh, dl  ; Moves head into proper register (DH)

    ; copies data from al, which contains the sector number, into ch then shifts that data 6 bits and ors it out which esentially empties the 
    ; lower part of the CH register (CL) but keeps the data that was previously in CL in the higher order bits of CH (sector number)
    MOV ch, al
    SHL ah, 6
    OR cl, ah ; cylinder: (LBA / sectors per track) / number of heads

    ; Now CX and DH both have the desired data in them!
    ;Restores the registers
    POP ax
    MOV dl, al
    POP ax

    RET

; Read disk sectors interrupt https://stanislavs.org/helppc/int_13-2.html
disk_read: ; Converts lba value to chs format. Tries to read using interrupt 13 

    ; Perserving registers that we are going to use
    PUSH ax
    PUSH bx
    PUSH cx
    PUSH dx
    PUSH di

    call lba_to_chs

    MOV ah, 02h
    MOV di, 3       ;Counter to loop (for this interrupt we are supposted to try up to 3 times)

retry:
    STC ;sets the carry!
    INT 13h
    jnc doneRead

    call diskReset

    ; loops if di is not zero
    DEC di
    TEST di, di
    JNZ retry 

; Prints failure message to screen and halts
failDiskRead:
    MOV si, read_failure
    CALL print
    hlt
    JMP halt

diskReset: ; resets the disk so we can attempt to read again. This is required and defined in docs
    ; perserve registers. push a pushes all general purpose register data onto the stack
    PUSHA

    MOV ah, 0   ; Resetting disk system
    STC         ; we need this command incase the bios doesn't set the carry. This makes sure it does
    INT 13h
    JC failDiskRead
    POPA ; restores registers
    RET

doneRead:
    ; restores system back to previous state
    POP di
    POP dx
    POP cx
    POP bx
    POP ax

    ret


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
read_failure DB 'Failed to read disk!', 0x0D, 0x0A, 0
TIMES 510-($-$$) DB 0    ; '$-$$' gives us the current size of the application and how many bytes it takes up. 
;510 is the location in memory we want to create data for. So esentially after the application is loaded and up till 510 bytes there will be empty data
DW 0AA55h   ; The bios is searching for this signature it is considered the signature of a valid boot record
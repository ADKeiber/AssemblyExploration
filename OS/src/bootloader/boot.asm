ORG 0x7c00 	; This is where the cpu looks to start the bootloader
BITS 16		; The bit amount of the OS. MOST os bootloaders are 16 bits for backwords compatibility but then evolve later to be x86 or 64 bit

JMP SHORT main ; SHORT JUMP is jumping into something inside of this file
NOP

bdb_oem:	  DB    'MSWIN4.1'
bdb_bytes_per_sector:	DW    512
bdb_sectors_per_clustor:DB    1
bdb_reserved_sector:	DW    1
bdb_fat_count:		DB    2
bdb_dir_entries_count:	DW    0E0h
bdb_total_sectors:	DW    2880
bdb_media_descriptor_type:  DB 0F0h
bdb_sectors_per_fat:	DW    9
bdb_sectors_per_track:	DW    18
bdb_heads:		DW    2
bdb_hidden_sectors:	DW    0
bdb_large_sector_count:	DD    0

ebr_drive_number:	DB    0
			DB    0
ebr_signature:		DB    29h
ebr_volume_id:		DB    12h,34h,56h,78h
ebr_volume_label:	DB    'Keiber OS  '
ebr_system_id:		DB    'FAT12   '

main:
   MOV ax, 0
   MOV ds, ax  ; DS keeps track of the data segment
   MOV es, ax  ; Sets the start point for the extra register
   MOV ss, ax  ; Sets the start address of the stop
   ; All are init to 0

   MOV sp, 0x7C00 ; Stets the stack to the starting point of the application so we can 'grow' the stack downwards

   ;MOV [ebr_drive_number], dl
   ;MOV ax, 1
   ;MOV cl, 1
   ;MOV bx, 0x7e00 ; Buffer located on the disk
   ;call disk_read

   MOV si, os_boot_msg
   CALL print
   
   ; 4 segments in fat 12
   ; reserved segment (BDB_RESERVED_SECTOR): 1 sector
   ; FAT:9 * 2 = 18 sectors
   ; Root Director: Starts at 19th sector
   ; Data
   
   MOV ax, [bdb_sectors_per_fat]
   MOV bl, [bdb_fat_count]
   XOR bh,bh
   MUL bx
   ADD ax, [bdb_reserved_sector] ; LBA of root directory
   PUSH ax

   MOV ax, [bdb_dir_entries_count]
   SHL ax, 5 ; ax *= 32
   XOR dx,dx
   DIV word [bdb_bytes_per_sector] ; (32 * num of entires) / bytes per sector = total sectors needed to read


   TEST dx, dx
   JZ rootDirAfter
   INC ax

rootDirAfter:
   MOV cl, al
   POP ax
   MOV dl, [ebr_drive_number]
   MOV bx, buffer
   CALL disk_read
   
   XOR bx, bx
   MOV di, buffer

searchKernel:
   MOV si, file_kernel_bin
   MOV cx, 11
   PUSH di 
   REPE CMPSB
   POP di
   JE foundKernel

   ADD di, 32
   INC bx
   CMP bx, [bdb_dir_entries_count]
   JL searchKernel
   
   JMP kernelNotFound

kernelNotFound:
   MOV si, msg_kernel_not_found
   CALL print

   HLT
   JMP halt

foundKernel:
   MOV ax, [di+26] ; di is address of the kernel and 26 is the offset to the first cluster
   MOV [kernel_cluster], ax

   MOV ax, [bdb_reserved_sector]
   MOV bx, buffer
   MOV cl, [bdb_sectors_per_fat]
   MOV dl, [ebr_drive_number]

   CALL disk_read
   
   MOV bx, kernel_load_segment
   MOV es, bx
   MOV bx, kernel_load_offset

loadKernelLoop:
   MOV ax, [kernel_cluster]
   ADD ax, 31
   MOV cl, 1
   MOV dl, [ebr_drive_number]

   CALL disk_read

   ADD bx, [bdb_bytes_per_sector]

   MOV ax, [kernel_cluster] ;(kernel_cluster * 3) / 2 = find next cluster
   MOV cx, 3
   MUL cx
   MOV cx, 2
   DIV cx

   MOV si, buffer
   ADD si, ax
   MOV ax, [ds:si]

   OR dx,dx
   JZ even

odd:
   SHR ax, 4
   JMP nextClusterAfter
even:
   AND ax, 0x0FFF

nextClusterAfter:
   CMP ax, 0x0ff8
   JAE readFinish

   MOV [kernel_cluster], ax
   JMP loadKernelLoop

readFinish:
   MOV dl, [ebr_drive_number]
   MOV ax, kernel_load_segment
   MOV ds, ax
   MOV es, ax

   JMP kernel_load_segment:kernel_load_offset

   HTL


halt:
   JMP halt

   ; input: LBA index in ax
   ; cx [bits 0-5]: sector number
   ; cx [bits 6-15]: cylinder
   ; dh: head
lba_to_chs:
   PUSH ax
   PUSH dx

   XOR dx, dx
   DIV word [bdb_sectors_per_track] ; LBA % secotrs per track + 1 <- sector
   INC dx   ; sector
   MOV cx, dx

   XOR dx, dx ; clear dx
   DIV word [bdb_heads]

   MOV dh, dl ; head: (LBA / secotrs per track) % number of heads
   MOV ch, al
   SHL ah, 6
   OR cl, ah   ; moves bits to proper location.. cylinder: (LBA / sectors per track)/ number of heads

   POP ax
   MOV dl, al
   POP ax
   RET

disk_read:
   ; converts lba value into chs format, then tries to read using interrupt 13
   ; perserve data
   PUSH ax
   PUSH bx
   PUSH cx
   PUSH dx
   PUSH di

   call lba_to_chs ; formats from LBA (logigical block addressing) to chs (cylinder, head, and sector)

   MOV ah, 02h
   MOV di, 3   ;counter for loop

retry:
   STC
   INT 13h
   jnc doneRead
   
   call diskReset

   DEC di
   TEST di,di
   JNE retry

failDiskRead:
   MOV si, read_failure
   CALL print
   HLT
   JMP halt

diskReset:
   PUSHA ; push all 16-bit general purpose registers on stack
   MOV ah, 0
   STC
   INT 13h
   JC failDiskRead
   POPA
   RET

doneRead:
   pop di
   pop dx
   pop cx
   pop bx
   pop ax
   RET

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

os_boot_msg: DB 'Loading...', 0x0D, 0x0A, 0 ; new line character and sentinel value
read_failure DB 'Failed to read disk!', 0x0D, 0x0A, 0
file_kernel_bin DB 'KERNEL  BIN'
msg_kernel_not_found DB 'KERNEL.BIN not found!'
kernel_cluster DW 0

kernel_load_segment EQU 0x2000
kernel_load_offset EQU 0

TIMES 510-($-$$) DB 0 ; '$-$$' gives the the size of the application
DW 0AA55h

buffer:
   

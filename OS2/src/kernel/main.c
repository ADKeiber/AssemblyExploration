#include "stdint.h"
#include "./stdio/stdio.h"
#include "disk/asmDisk.asm"

void _cdecl cstart_(){
    uint8_t error;
    x86_Disk_reset(0, &error);
    printf("ERROR %d\r\n", error);
}
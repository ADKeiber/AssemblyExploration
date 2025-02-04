#include "stdint.h"
#include "stdio.h"

void _cdecl cstart_(){
    puts("Hello world from C!\r\n");
    printf("Formatted: %% %c %s\r\n", 'f', "Hello");
}
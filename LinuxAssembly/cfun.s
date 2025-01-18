extern printf  ;NOTE: Imports printf from C
extern exit    ;NOTE: Tells nasm to import exit from C

section .data
   msg DD "Hello World!", 0 ;NOTE: 0 is a null terminator
   fmt DB "Output is: %s", 10 ; NOTE: 10 is a new line character

section .text
global main

main: ; NOTE: Since we are running our object through GCC we actually need to have a main method instead of something like start
   PUSH msg
   PUSH fmt ; These must be in reverse of how the c function uses them printf(fmt, msg) because of its "stack" nature
   CALL printf ; CALLS the printf function
   PUSH 1      ; pushed 1 (will be the exit code)
   CALL exit   ; calls exit:


segment .bss
   input1 resb 10    ; reserves 10 bytes for input1 (can store 10 characters)
   input2 resb 10    ; also reserves 10 bytes
   finalString resb 20 ;contains the two string combines

segment .data
   msg1 db "Enter a string to be mixed (max length 10)", 0xA, 0xD  ;0xA is a newline character and 0xD is a 'carriage return character' basically moves cursor to next line
   len1 equ $ - msg1          ; NOTE this must be declared after entering msg1 becuase it calculates difference between top of stack and the pointer for a var. SO if another is added it will be placed on top of msg1 making equ display much more than the intended amount
   msg2 db "Enter another string to be mix (max length 10)", 0xA, 0xD ; same as above
   len2 equ $ - msg2

global .text
   global _start

_start:
   mov eax, 4     ; system call to write data
   mov ebx, 1     ; std out 
   mov ecx, msg1  ; puts message 1 in the ecx register which will have some action performed on it based on eax and ebx values (write data out)
   mov edx, len1  ; sets the length of the expected output
   int 0x80       ; calls the kernel and output the message

   mov eax, 3     ; system call to read data
   mov ebx, 0     ; std in
   mov ecx, input1; 
   mov edx, 10    ; sets the bytes size to be populated to 10
   int 0x80

   mov eax, 4     ; system call to write data
   mov ebx, 1     ; std out 
   mov ecx, msg2  ; puts message 1 in the ecx register which will have some action performed on it based on eax and ebx values (write data out)
   mov edx, len2  ; sets the length of the expected output
   int 0x80       ; calls the kernel and output the message

   mov eax, 3     ; system call to read data
   mov ebx, 0     ; std in
   mov ecx, input2; 
   mov edx, 10    ; sets the bytes size to be populated to 10
   int 0x80

exit:
   mov eax, 1     ; system call to exit
   xor ebx, ebx   ; sets ebx to zero with xor 
   int 0x80       ; kernel call (exits the system)


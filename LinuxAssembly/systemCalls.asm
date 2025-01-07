section .data                             ; Data segment
   userMsg db 'Please enter a number: '   ; Ask the user to enter a number
   lenUserMsg equ $-userMsg               ; length of the message
   dispMsg db 'You have entered: '
   lenDispMsg equ $-dispMsg

section .bss      ; uninit data
   num resb 5     

section .text     ; code segment
   global _start

_start:           ; User prompt
   mov eax, 4
   mov ebx, 1
   mov ecx, userMsg
   mov edx, lenUserMsg
   int 80h

   ; Read and store the user input
   mov eax, 3
   mov ebx, 2
   mov ecx, num
   mov edx, 5     ; 5 bytes (number, 1 for sign) of that information
   int 80h

   ;Out the message 'the entered number is: '
   mov eax, 4
   mov ebx, 1
   mov ecx, dispMsg
   mov edx, lenDispMsg
   int 80h

   ;Output the number entered
   mov eax, 4
   mov ebx, 1
   mov ecx, num ;NOTE if this input is over 5 bytes it will be cut off and only display 5 bytes. NOTE on that note... the data isn't stored either
   mov edx, 5 ; We stored this as 5 bytes in line 24 needs to remain consistent size!
   int 80h

   ; Exit code
   mov eax, 1
   mov ebx, 0
   int 80h

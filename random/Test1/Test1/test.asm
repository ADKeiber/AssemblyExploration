.386                  ; indicates that a program will use the 32- bit instruction and register set that was introdcued in the 80386 intel processor
.model flat, stdcall  ; flat -> program sees memory as a single contiguous address space, where code and data can be accessed directly without needing seperate segment registers...
                      ; stdcall -> Standard call convention means a called function is responsible for clearning up the stack after execution
.stack 4096           ; Allocates 4096 bytes in memory for the applicatoin

ExitProcess PROTO, dwExitCode:DWORD ; Sets an exit function that takes in a DWORD value.. Line 15 uses this and passes in a 4 byes (DWORD) eax value

.data
myList DWORD 2, 3, 5, 8 

.code
main PROC
  mov eax, 7
  add eax, 8
  mov ebx, [myList]
  add eax, ebx
;  move ebx, [myList + 1]
;  add eax, ebx
  INVOKE ExitProcess, eax
main ENDP

END main        

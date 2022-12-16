
section .text

global addsub

addsub:
    push ebp            ; Save the value of ebp on the stack
    mov ebp, esp        ; Set ebp to the current value of esp
    push ebx            ; Save ebx on the stack

    mov ebx, [ebp+8]
    cmp byte [ebp+16], 2bh ; Plus
    jz add              
    cmp byte [ebp+16], 2dh ; Minus
    jz sub              

add:
    add ebx, [ebp+12]
    jmp cleanup          

sub:
    sub ebx, [ebp+12]   ; Subtract num2 from num1 and store the result in ebx
    jmp cleanup; Jump to end label

cleanup:
    pushfd
    pop ecx
    mov edx, [ebp + 20]
    mov [edx], ecx ; Write in flags

    mov eax, ebx

    mov esp, ebp
    pop ebp
    ret                 

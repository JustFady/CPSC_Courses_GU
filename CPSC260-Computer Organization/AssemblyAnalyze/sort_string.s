bits 64

section .data
    input db "GONZAGABULLDOGS", 10, 0  ; Input string with '\n' and null terminator
    length equ $ - input - 1           ; Length of the string excluding '\n' and null terminator

section .bss
    sorted resb length + 2             ; Buffer to store the sorted string

section .text
    global _start

_start:
    ; Print original string
    mov eax, 1                  ; sys_write
    mov edi, 1                  ; stdout
    mov rsi, input              ; Address of the original string
    mov edx, length + 1         ; Length of the original string
    syscall

    ; Copy input to sorted buffer
    mov ecx, length
    mov rsi, input
    mov rdi, sorted
    
copy_loop:
    lodsb
    stosb
    loop copy_loop

    ; Add '\n' and null terminator to sorted buffer
    mov byte [sorted + length], 10
    mov byte [sorted + length + 1], 0

    ; Bubble sort
    mov ecx, length
    
outer_loop:
    dec ecx
    jz done_sorting
    mov rsi, sorted
    mov rdi, sorted + 1
    mov ebx, ecx

inner_loop:
    mov al, [rsi]
    mov ah, [rdi]
    cmp al, ah
    jbe skip_swap
    ; Swap characters
    mov [rsi], ah
    mov [rdi], al
    
skip_swap:
    inc rsi
    inc rdi
    dec ebx
    jnz inner_loop
    jmp outer_loop

done_sorting:
    ; Print sorted string
    mov eax, 1                  ; sys_write
    mov edi, 1                  ; stdout
    mov rsi, sorted             ; Address of the sorted string
    mov edx, length + 1         ; Length of the sorted string
    syscall

    ; Exit program
    mov eax, 60                 ; sys_exit
    xor edi, edi                ; Status 0
    syscall

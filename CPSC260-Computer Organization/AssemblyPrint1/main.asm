section .data
    message db "Go Zags!", 0x0A  ; the message to print, followed by a newline character
    message_len equ $ - message  ; length of the message

section .text
    global _start

_start:
    ; write system call (sys_write)
    ; syscall number for sys_write is 1
    mov rax, 1          ; syscall number (sys_write)
    mov rdi, 1          ; file descriptor (1 = stdout)
    mov rsi, message    ; pointer to the message
    mov rdx, message_len ; length of the message
    syscall             ; make the syscall

    ; exit system call (sys_exit)
    ; syscall number for sys_exit is 60
    mov rax, 60         ; syscall number (sys_exit)
    xor rdi, rdi        ; exit code 0
    syscall             ; make the syscall

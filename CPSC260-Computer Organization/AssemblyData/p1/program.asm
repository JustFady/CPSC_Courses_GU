section .data
    result db "Gallons: %ld, Horsepower: %ld, MPH: %ld, X: %ld", 10, 0, 0
section .bss
    temp resq 1
section .text
    extern printf
    global main
main:
    ; Initialize variables in registers
    ; int length = 24;
    mov rax, 24            ; rax = length
    ; int height = 16;
    mov rbx, 16            ; rbx = height
    ; int width = 12;
    mov rcx, 12            ; rcx = width
    ; Calculate gallons
    ; int gallons = (length * width * height) / 231;
    imul rax, rcx          ; rax = length * width
    imul rax, rbx          ; rax = length * width * height
    mov r11, 231           ; r11 = 231 (divisor)
    cqo                    ; sign extend rax into rdx
    idiv r11               ; rax = (length * width * height) / 231
    mov r8, rax            ; r8 = gallons
    ; Initialize RPM
    ; int rpm = 5000;
    mov rsi, 5000          ; rsi = rpm
    ; Calculate horsepower
    ; int horsepower = (((rpm - 2000) * (rpm - 2000)) / 150000) - 15;
    sub rsi, 2000          ; rsi = rpm - 2000
    mov rdi, rsi           ; store (rpm - 2000) in rdi
    imul rdi, rsi          ; rdi = (rpm - 2000) * (rpm - 2000)
    mov r11, 150000        ; r11 = 150000 (divisor)
    mov rax, rdi           ; move rdi to rax for division
    cqo                    ; sign extend rax into rdx
    idiv r11               ; rax = ((rpm - 2000) * (rpm - 2000)) / 150000
    sub rax, 15            ; rax = horsepower - 15
    mov r9, rax            ; r9 = horsepower
    ; Initialize meters and seconds
    ; int meters = 5000;
    mov r10, 5000          ; r10 = meters
    ; int seconds = 960;
    mov r11, 960           ; r11 = seconds
    ; Calculate mph
    ; int mph = (3600 * meters) / (1609 * seconds);
    mov r12, 3600          ; r12 = 3600 (multiplier)
    imul r10, r12          ; r10 = 3600 * meters
    mov r12, 1609          ; r12 = 1609 (divisor)
    imul r11, r12          ; r11 = 1609 * seconds
    mov rax, r10           ; move r10 to rax for division
    cqo                    ; sign extend rax into rdx
    idiv r11               ; rax = (3600 * meters) / (1609 * seconds)
    mov r10, rax           ; r10 = mph
    ; Calculate x
    ; int x = ((17 * 23) / 3) % 3;
    mov r12, 17            ; r12 = 17 (multiplier)
    imul r13, r12, 23      ; r13 = 17 * 23
    mov r12, 3             ; r12 = 3 (divisor)
    mov rax, r13           ; move r13 to rax for division
    cqo                    ; sign extend rax into rdx
    idiv r12               ; rax = (17 * 23) / 3
    mov r13, rdx           ; rdx contains the remainder
    mov r12, 3             ; r12 = 3 (divisor for modulus)
    mov rax, r13           ; move remainder to rax
    cqo                    ; sign extend rax into rdx
    idiv r12               ; rax = ((17 * 23) / 3) % 3
    mov r11, rax           ; r11 = x (remainder)

    ; Ensure stack alignment before calling printf
    push rbp                ; save the base pointer
    mov rbp, rsp            ; set the base pointer to the current stack pointer
    and rsp, -16            ; align the stack pointer to a 16-byte boundary

    ; Print results
    mov rdi, result        ; rdi = format string
    mov rsi, r8            ; rsi = gallons
    mov rdx, r9            ; rdx = horsepower
    mov rcx, r10           ; rcx = mph
    mov r8, r11            ; r8 = x
    call printf            ; call printf function

    ; Restore stack
    mov rsp, rbp            ; restore the original stack pointer
    pop rbp                 ; restore the base pointer

    ; Exit program
    mov rax, 60            ; system call number (sys_exit)
    xor rdi, rdi           ; status 0
    syscall                ; call kernel
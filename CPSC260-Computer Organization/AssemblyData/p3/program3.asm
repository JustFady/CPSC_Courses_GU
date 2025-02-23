.global _start
.text

_start:
    mov     $mystr, %rsi   # load address of string into %rsi

uppercase_loop:
    movb    (%rsi), %al    # load current character into %al
    cmpb    $0, %al        # check if it is null terminator
    je      write          # if yes, jump to write
    cmpb    $'a', %al      # check if it is a lowercase letter
    jl      next_char      # if not, jump to next character
    cmpb    $'z', %al      # check if it is a lowercase letter
    jg      next_char      # if not, jump to next character
    subb    $32, %al       # convert to uppercase by subtracting 32
    movb    %al, (%rsi)    # store uppercase character back in string

next_char:
    inc     %rsi           # move to next character
    jmp     uppercase_loop # continue loop

write:
    mov     $1, %rax       # system call 1 for write
    mov     $1, %rdi       # file descriptor 1 (stdout)
    mov     $mystr, %rsi   # address of string to output
    mov     $len, %rdx     # number of bytes
    syscall                # call kernel to output string

exit:
    mov     $60, %rax      # system call 60 for exit
    xor     %rdi, %rdi     # exit status 0
    syscall                # call kernel to exit

.section .data
mystr:  .ascii "Go Zags\n"     # initial string
len:    .equ  len_of_mystr,  - mystr  # length of string
len_of_mystr:

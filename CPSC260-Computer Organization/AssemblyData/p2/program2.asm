.global _start
.text

_start:
    movb    mystr, %al
    addb    $32, %al      # make "H" lowercase
    movb    %al, mystr

    movq    $mystr, %rax  # treats mystr as address literal
    addq    $1, %rax      # add one to address
    movb    (%rax), %bl   # treats %rax as pointer (follow address)
    subb    $32, %bl      # make "e" uppercase
    movb    %bl, (%rax)   # store result (again as pointer)

    # Replace additional 'e' with 'E'
    mov     $mystr, %rax
loop:
    cmpb    $'e', (%rax)
    je      replace
    cmpb    $0, (%rax)    # Check for null terminator
    je      write
    inc     %rax
    jmp     loop

replace:
    movb    $'E', (%rax)
    inc     %rax
    jmp     loop

write:
    # write(1, mystr, strlen)
    movq    $1, %rax      # system call 1 is write
    movq    $1, %rdi      # file handle 1 is stdout
    movq    $mystr, %rsi  # address of string to output
    movq    $mylen, %rdx  # number of bytes
    syscall

# exit(0)
    movq    $60, %rax     # system call 60 is exit
    xorq    %rdi, %rdi    # we want return call 0
    syscall

.data
mystr:  .ascii "Hello, World!\n"
        .equ mylen, (. - mystr)
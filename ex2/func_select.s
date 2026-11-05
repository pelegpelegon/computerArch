.extern printf
.extern scanf
.extern pstrlen
.extern swapCase
.extern pstrijcpy
.extern pstrcmp
.extern pstrrev


.section .rodata
jump_table:
    .quad .chose_31
    .quad .invalid_option # 32
    .quad .chose_33
    .quad .chose_34
    .quad .invalid_option # 35
    .quad .invalid_option # 36
    .quad .invalid_option # 37
    .quad .invalid_option # 38
    .quad .invalid_option # 39
    .quad .invalid_option # 40
    .quad .chose_41
    .quad .chose_42
invalid_message:
    .string "invalid option!\n"
# ADDED HERE A LINE DROP
message_length_31:
    .string "first pstring length: %d, second pstring length: %d\n"
message_print_pstr:
    .string "length: %d, string: %s\n"
scanf_get_int:
    .string "%d"
first_bigger_message:
    .string "First string is larger\n"
first_smaller_message:
    .string "First string is smaller\n"
both_equal_message:
    .string "Strings are equal\n"


.section .text
.global run_func
.type run_func, @function
run_func:
    # Enter
    pushq %rbp
    movq %rsp, %rbp

    # subtracts 31 from the number input,
    # and compares it to 11 (the number of options in the jump table)
    # edi = user's input (edi) - 31
    subl $31, %edi
    cmpl $11, %edi
    ja .invalid_option
    # goes to jump_table + edi * 8
    jmp *jump_table(,%edi, 8)


.chose_31:

    # gets the first pstr's length
    # saves the second pointer in the stack
    pushq %rdx
    movq %rsi, %rdi
    xorq %rax, %rax
    call pstrlen
    popq %rsi
    pushq %rax

    # gets the second pstr's length
    movq %rsi, %rdi
    xorq %rax, %rax
    call pstrlen

    # prints and exists
    leaq message_length_31(%rip), %rdi
    # the first length
    popq %rsi 
    movq %rax, %rdx
    call printf
    jmp .exit

.chose_33:
    # first pointer -> rbp - 8
    pushq %rsi
    # second pointer -> rbp - 16
    pushq %rdx


    # calls pstrlen swapCase on the first string
    # (pointer already in rdi)
    movq %rsi, %rdi
    xorq %rax, %rax
    call pstrlen
    # first pstr's length -> rbp - 24
    pushq %rax

    # restores the first pointer
    # and call swapCase on the first string
    movq -8(%rbp), %rdi
    xorq %rax, %rax
    call swapCase

    # calls swapCase and len on the second string
    # (need to restore the pointer after call in case the call ruins it)
    movq -16(%rbp), %rdi
    xorq %rax, %rax
    call pstrlen
    pushq %rax
    # second pstr's length -> rbp - 32

    movq -16(%rbp), %rdi
    xorq %rax, %rax
    call swapCase

    jmp .print_two_pstrs

.chose_34:
    # first pointer -> rbp - 8
    pushq %rsi
    # second pointer -> rbp - 16
    pushq %rdx

    # allocates more memory for the input, and aligning the stack
    subq $16, %rsp
    leaq scanf_get_int(%rip), %rdi
    leaq -20(%rbp), %rsi
    xorq %rax, %rax
    call scanf
    # i = rbp - 20


    leaq scanf_get_int(%rip), %rdi
    leaq -24(%rbp), %rsi
    call scanf
    # j = rbp - 24


    # transfers the first bytes of i and j (to the function)
    xorq %rdx, %rdx
    xorq %rcx, %rcx
    movb -20(%rbp), %dl
    movb -24(%rbp), %cl

    # calls the function
    movq -8(%rbp), %rdi
    movq -16(%rbp), %rsi
    call pstrijcpy

    # gets the first string length
    movq -8(%rbp), %rdi
    xorq %rax, %rax
    call pstrlen
    movq %rax, -24(%rbp)

    # gets the second string length
    movq -16(%rbp), %rdi
    xorq %rax, %rax
    call pstrlen
    movq %rax, -32(%rbp)

    jmp .print_two_pstrs


.chose_41:

    # calls pstrcmp
    movq %rsi, %rdi
    movq %rdx, %rsi
    call pstrcmp

    cmp $0, %rax
    je .both_equal
    jb .first_smaller

.first_bigger:
    leaq first_bigger_message(%rip), %rdi
    xorq %rax, %rax
    call printf
    jmp .exit

.first_smaller:
    leaq first_smaller_message(%rip), %rdi
    xorq %rax, %rax
    call printf
    jmp .exit

.both_equal:
    leaq both_equal_message(%rip), %rdi
    xorq %rax, %rax
    call printf
    jmp .exit

.chose_42:
    # first pointer -> rbp - 8
    pushq %rsi
    # second pointer -> rbp - 16
    pushq %rdx


    # calls the function
    movq -8(%rbp), %rdi
    xorq %rax, %rax
    call pstrrev

    movq -16(%rbp), %rdi
    xorq %rax, %rax
    call pstrrev

    # gets the first string length
    movq -8(%rbp), %rdi
    xorq %rax, %rax
    call pstrlen
    pushq %rax

    # gets the second string length
    movq -16(%rbp), %rdi
    xorq %rax, %rax
    call pstrlen
    pushq %rax

    jmp .print_two_pstrs



.invalid_option:
    leaq invalid_message(%rip), %rdi
    xorq %rax, %rax
    call printf

.exit:
    xorq %rax, %rax
    movq %rbp, %rsp
    popq %rbp
    ret

# MAKE SURE THE FOLLOWING STACK FRAME:
# first pointer -> rbp - 8
# second pointer -> rbp - 16
# first length -> rbp - 24
# second length -> rbp - 32
.print_two_pstrs:
    # prints first pstr
    leaq message_print_pstr(%rip), %rdi
    movq -24(%rbp), %rsi
    movq -8(%rbp), %rdx
    xorq %rax, %rax
    call printf

    # prints the second pstr
    leaq message_print_pstr(%rip), %rdi
    movq -32(%rbp), %rsi
    movq -16(%rbp), %rdx
    xorq %rax, %rax
    call printf

    jmp .exit

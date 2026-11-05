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
    .string "invalid option!\n”

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
    movq %rsp %rbp

    # subtracts 31 from the number input,
    # and compares it to 11 (the number of options in the jump table)
    subl $31, %edi # edi = user's input (edi) - 31
    cmpl $11, %edi
    ja .invalid_option
    jmp *jump_table(,%edi, 8) # goes to jump_table + edi * 8


.chose_31:

    # gets the first pstr's length
    pushq %rdx # saves the second pointer in the stack
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
    movq message_length_31, %rdi
    popq %rsi # the first length
    movq %rax, %rdx
    call printf
    jmp .exit

.chose_33:
    pushq %rsi # first pointer -> rbp
    pushq %rdx # second pointer -> rbp + 8

    # calls pstrlen swapCase on the first string
    # (pointer already in rdi)
    movq %rsi, %rdi
    xorq %rax, %rax
    call pstrlen
    pushq %rax # first pstr's length -> rbp - 16

    # restores the first pointer
    # and call swapCase on the first string
    movq (%rbp), %rdi
    xorq %rax, %rax
    call swapCase

    # calls swapCase and len on the second string
    # (need to restore the pointer after call in case the call ruins it)
    movq (%rbp, 8, -1), %rdi
    xorq %rax, %rax
    call pstrlen
    pushq %rax # second pstr's length -> rbp - 24
    movq (%rbp, 8, -1), %rdi
    xorq %rax, %rax
    call swapCase

    jmp .print_two_pstrs

.chose_34:
    pushq %rsi # first pointer -> rbp
    pushq %rdx # second pointer -> rbp - 8

    # allocates more memory for the input, and aligning the stack
    subq %rsp, 16
    movq scanf_get_int, %rdi
    leaq (%rbp, 16, -1), %rsi
    call scanf # i = rsp - 16

    movq scanf_get_int, %rdi
    leaq (%rbp, 20, -1), %rsi
    call scanf # j = rsp - 20

    # transfers the first bytes of i and j (to the function)
    xorq %rdx, %rdx
    xorq %rcx, %rcx
    movb (%rbp, 16, -1), %dl
    movb (%rbp, 20, -1), %cl

    # calls the function
    movq (%rbp), %rdi
    movq (%rbp, 8, -1), %rsi
    call pstrijcpy

    # gets the first string length
    movq (%rbp), %rdi
    xorq %rax, %rax
    call pstrlen
    movq %rax, (%rbp, 16, -1)

    # gets the second string length
    movq (%rbp, 8, -1), %rdi
    xorq %rax, %rax
    call pstrlen
    movq %rax, (%rbp, 24, -1)

    jmp .print_two_pstrs


.chose_41:

    # calls pstrcmp
    movq %rsi, %rdi
    movq %rdx, %rsi
    call pstrcmp

    cmp $0, %rax


.first_bigger:
    movq first_bigger_message, %rdi
    xorq %rax, %rax
    call printf
    jmp .exit

.first_smaller:
    movq first_smaller_message, %rdi
    xorq %rax, %rax
    call printf
    jmp .exit

.both_equal:
    movq both_equal_message, %rdi
    xorq %rax, %rax
    call printf
    jmp .exit























.chose_42:
.invalid_option:
    movq invalid_message, %rdi
    xorq %rax, %rax
    call printf


# MAKE SURE THE FOLLOWING STACK FRAME:
# first pointer -> rbp
# second pointer -> rbp - 8
# first length -> rbp - 16
# second length -> rbp - 24
.print_two_pstrs:
    # prints and exists
    movq message_print_pstr, %rdi

    # prints first pstr
    movq (%rsp, 16, -1), %rsi
    movq (%rsp), %rdx
    xorq %rax, %rax
    call printf

    # prints the second pstr
    movq (%rsp, 24, -1), %rsi
    movq (%rsp, 8, -1), %rdx
    xorq %rax, %rax
    call printf

    jmp .exit



.exit:
    xorq %rax, %rax
    movq %rbp, %rsp
    popq %rbp
    ret
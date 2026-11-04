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
    movq %rsi, %rdi
    xorq %rax, %rax
    call pstrlen
    movq %rax, %rcx

    # gets the second pstr's length
    movq %rdx, %rdi
    xorq %rax, %rax
    call pstrlen

    # prints and exists
    movq message_length_31, %rdi
    movq %rcx, %rsi
    movq %rax, %rdx
    call printf
    jmp .exit

.chose_33:
    # calls pstrlen swapCase on the first string
    # (pointer already in rdi)
    xorq %rax, %rax
    call pstrlen
    movq %rax, %r8 # r8 = first pstr's length
    xorq %rax, %rax
    call swapCase

    # calls swapCase on the second string
    # (rax currently stores the first string's pointer)
    movq %rsi, %rdi
    movq %rax, %rsi
    xorq %rax, %rax
    call pstrlen
    movq %rax, %r9 # r9 - second pstr's length
    xorq %rax, %rax
    call swapCase

    jmp .print_two_pstrs

.chose_34:


# MAKE SURE BEFORE I CALL A FUNCTION BACK UP EVERYTHING THATS ON REGISTER TO THE STACK IN CASE IT IS CHANGED

.chose_41:
.chose_42:
.invalid_option:
    movq invalid_message, %rdi
    xorq %rax, %rax
    call printf

.exit:
    xorq %rax, %rax
    movq %rbp, %rsp
    popq %rbp
    ret

# MAKE SURE RDI = SECOND PSTR, RSI = FIRST PSTR
# AND R8 = FIRST'S LENGTH, R9 = SECOND'S LENGTH
.print_two_pstrs:
    # prints and exists
    movq %rdi, %r10 # r10 = second pstr address (rdi and rsi swapped earlier)
    movq %rsi, %r11 # r11 = first pstr address
    movq message_print_pstr, %rdi

    # prints first pstr
    movq %r8, %rsi
    movq 1(%r11), %rdx
    xorq %rax, %rax
    call printf

    # prints the second pstr
    movq %r9, %rsi
    movq 1(%r10), %rdx
    xorq %rax, %rax
    call printf

    jmp .exit
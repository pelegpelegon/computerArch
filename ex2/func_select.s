.extern printf
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

invalid_message: .string "invalid option!\n”







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
    # do something

.chose_33:

.chose_34:
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


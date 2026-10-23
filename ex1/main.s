/* 333135440 Peleg Sacher */
.extern printf
.extern scanf
.extern srand
.extern rand

.section .data
    M: .long 5
    N: .long 10
    
.section .bss
    rounds_won: .skip 4, 0x0
    user_guess: .skip 4, 0x0
    user_seed: .skip 4, 0x0
    rolled_number: .skip 4
    difficulty: .skip 1
    double_or_nothing_answer: .skip 1

.section .rodata
enter_config:
    .string "Enter configuration seed: "
wrong_guess:
    .string "Incorrect. "
win_massage:
    .string "Congratz! You won %d rounds!\n"
lose_massage:
    .string "\nGame over, you lost :(. The correct answer was %d"
enter_guess:
    .string "What is your guess? "
double_or_nothing:
    .string "Double or nothing! Would you like to continue to another round? (y/n) "
ask_difficulty:
    .string "Would you like to play in easy mode? (y/n) "
number_below:
    .string "Your guess was below the actual number ...\n"
number_above:
    .string "Your guess was above the actual number ...\n"
scanf_get_int:
    .string "%d"
scanf_get_char:
    .string " %c"

test_show_num:
    .string "%d this is the number\n"

.section .text
.global main
.type   main, @function
main:
    # not sure 
    pushq %rbp
    movq %rsp, %rbp



    # asks for a seed number
    movq $enter_config, %rdi
    xorq %rax, %rax
    call printf

    # get seed number from the user
    movq $scanf_get_int, %rdi
    movq $user_seed, %rsi
    xorq %rax, %rax
    call scanf

    # intializes rand's seed
    movq user_seed, %rdi
    xorq %rax, %rax
    call srand

    jmp .set_difficulty

.set_difficulty:
    # asks if the user want easy mode
    movq $ask_difficulty, %rdi
    xorq %rax, %rax
    call printf

    # gets user's answer
    movq $scanf_get_char, %rdi
    movq $difficulty, %rsi
    xorq %rax, %rax
    call scanf

    jmp .roll_number


.roll_number:
    # rolls a number
    xorq %rax, %rax
    call rand

    # gets the mudolu of the rolled number to get 1 to N
    xorq %rdx, %rdx
    movl N, %ecx
    divl %ecx # here rdx in range 0 to N - 1
    incl %edx # here rdx in range 1 to N
    movl %edx, rolled_number

    /*






            THIS IS FOR TESTING REMOVE LATER
                        |
                        |
                        |
                        |
                        |
                        \/




    */
    movq $test_show_num, %rdi
    movl rolled_number, %esi
    xorq %rax, %rax
    call printf

    # checks the users difficulty answer
    movb difficulty, %bl
    # compares answer to "n" (no to easy mode)
    cmpb $0x6E, %bl
    je .normal_mode
    jmp .easy_mode




.easy_mode:

.normal_mode:


    movq $enter_guess, %rdi
    xorq %rax, %rax
    call printf

    movq $scanf_get_int, %rdi
    movq $user_guess, %rsi
    xorq %rax, %rax
    call scanf

    movl user_guess, %eax
    movl rolled_number, %ebx
    cmpl %eax, %ebx
    je .currect_guess




.currect_guess:
    # adds one win
    incl rounds_won

    # asks for double or nothing
    movq $double_or_nothing, %rdi
    xorq %rax, %rax
    call printf

    # gets answer for double or nothing
    movq $scanf_get_char, %rdi
    movq $double_or_nothing_answer, %rsi
    xorq %rax, %rax
    call scanf

    movb double_or_nothing_answer, %bl
    # compares answer to "n" (no to double or nothing)
    cmpb $0x6E, %bl
    je .end_game
    
    # when the answer is yes to double or nothing

    # multiplies N and the seed by 2
    movl N, %ebx
    shll $1, %ebx
    movl %ebx, N

    movl user_seed, %ebx
    shll $1, %ebx
    movl %ebx, user_seed

    # changes rand's seed
    movq user_seed, %rdi
    xorq %rax, %rax
    call srand

    jmp .roll_number



.end_game:
    # Exit
    xorq %rax, %rax
    movq %rbp, %rsp
    popq %rbp
    ret



/* 333135440 Peleg Sacher */
.extern printf
.extern scanf
.extern srand
.extern rand

.section .data
    M: .skip 4, $5
    N: .skip 4, $10
    
.section .bss
    rounds_won: .skip 4, 0x0
    user_guess: .skip 4, 0x0
    user_seed: .skip 4, 0x0
    difficulty: .skip 1

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
    .string "What is your guess?"
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
    .string "%c"

.section .text
.global main
.type   main, @function
main:
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
    movq $user_seed, %rdi
    xorq %rax %rax
    call srand

    # starts game
    call set_difficulty

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
    /*
    movq
    
    6E*/



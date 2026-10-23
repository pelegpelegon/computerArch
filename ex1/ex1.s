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
easy_mode:
    .string "Would you like to play in easy mode? (y/n) "
number_below:
    .string "Your guess was below the actual number ...\n"
number_above:
    .string "Your guess was above the actual number ...\n"
scanf_config:
    .string "%d"

.section .text
.global main
.type   main, @function
main:
    # asks for a seed number
    movq $enter_config, %rdi
    xorq %rax, %rax
    call printf

    #get seed number from the user
    movq $scanf_config, %rdi
    movq $user_seed, %rsi
    xorq %rax, %rax
    call scanf

    #intializes rand's seed
    movq $user_seed, %rdi
    xorq %rax %rax
    call srand



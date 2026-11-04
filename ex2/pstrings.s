.extern printf
.section .rodata
invalid_range_message:
    .string "invalid input!\n"


.section .text
.global swapCase
.type swapCase, @function
swapCase:
    # Enter
    pushq %rbp
    movq %rsp, %rbp

    # gets the pstring's length,
    # the pstring's pointer is still in %rdi
    xorq %rax, %rax
    call pstrlen # now al = pstring.len

    # makes rcx point to the start of the string
    movq %rdi, %rcx
    incq %rcx
    cmpb $0, %al # in case length is 0
    ja .while_loop

# exist, for the swapCase function
.swapCase_exit:
    # Exits
    xorq %rdi, %rax # just returns the given pointer
    movq %rbp, %rsp
    popq %rbp
    ret

# the while loop that goes through the string
.while_loop:
    # dl (first byte in rdx) = the next byte (next char)
    movb (%rcx), %dl

    # checks if capital
    subq $'A', %dl # makes 'A' the new zero
    cmpb $25, %dl # compares with Z's dec value - 'A' dec value
    jb .capital_letter

    # checks if lower case
    subq $32, %dl # makes 'a' the new zero, 32 = DEC('a' - 'A')
    cmpb $25, %dl # compares with z's dec value - 'a' dec value
    jb .lower__letter

# moves to the next iteration in the while loop
.next:
    # moves rcx to the next byte and decrements al
    incq %rcx
    decb %al

    # checks while condition (al > 0)
    cmpb $0, %al
    ja .while_loop
    jmp .swapCase_exit

# here if the current letter is capital and changes it to lower case
.capital_letter:
    # changes to lower case,
    # 33 is the difference between capital and lower case in dec
    addb $33, (%rcx)
    jmp .next

# here if the current letter is lower case and changes it to capital
.lower_letter:
    # changes to uppper case,
    # 33 is the difference between capital and lower case in dec
    subb $33, (%rcx)
    jmp .next




.global pstrlen
.type pstrlen, @function
pstrlen:
    # Enter
    pushq %rbp
    movq %rsp, %rbp

    # gets the pstring's length, saves it in al (rax's first byte)
    # al = first byte of pstring, which is the length
    xorq %rax, %rax
    movb (%rdi), %al

    # exits
    movq %rbp, %rsp
    popq %rbp
    ret




.global pstrijcpy
.type pstrijcpy, @function
pstrijcpy:
    # Enter
    pushq %rbp
    movq %rsp, %rbp

    # gets the dest's length (pointer is already in rdi)
    xorq %rax, %rax
    call pstrlen
    
    # moves dest's length to a different register,
    # and moves source to rdi and gets its length
    # in the end of this:
    # rax = source's length
    # r9 = dest's length
    # r8 points to dest
    # rsi points to source
    # rdx = i
    # rcx = j
    xorq %rcx, %rcx
    movb %rax, %r9
    movq %rdi, %r8
    movq %rsi, %rdi
    xorq %rax, %rax
    call pstrlen

.check_valid_length:
    # checks if i > j
    cmpq %rcx, %rdx
    ja .invalid_range

    # checks if j => source's length
    comq %rax, %rcx
    jae .invalid_range

    # checks if j => dest's length
    comq %r9, %rcx
    jae .invalid_range

# loops through the strings range
.pstrijcpy_loop:
    # saves the source's string i's char in r10
    movq %rax(1, %rdx, 1), %r10

    # put the char in dest
    movq %r10, %r9(1, %rdx, 1)

    # increments to the next iteration
    incq %rdx
    cmpq %rcx, %rdx
    ja .pstrijcpy_exit # jumps if i > j
    jmp .pstrijcpy_loop

# in case the range is invalid prints what's needed
.invalid_range:
    movq invalid_range_message, %rdi
    call printf
    .jmp .pstrijcpy_exit

.pstrijcpy_exit:
    popq %rbp
    movq %r8, %rax
    ret




.global pstrcmp
.type pstrcmp, @function


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

    cmpb $0, %al
    ja .while_loop

# exist, for the swapCase function
.swapCase_exit:
    # Exits
    xorq %rax, %rax
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
    

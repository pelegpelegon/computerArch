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
    call pstrlen
    # now al = pstring.len


    # makes rcx point to the start of the string
    movq %rdi, %rcx
    incq %rcx
    # in case length is 0
    cmpb $0, %al
    ja .while_loop

# exist, for the swapCase function
.swapCase_exit:
    # Exits
    # just returns the given pointer
    xorq %rdi, %rax 
    movq %rbp, %rsp
    popq %rbp
    ret

# the while loop that goes through the string
.while_loop:
    # dl (first byte in rdx) = the next byte (next char)
    movb (%rcx), %dl

    # checks if capital
    # makes 'A' the new zero
    subb $'A', %dl
    # compares with Z's dec value - 'A' dec value
    cmpb $25, %dl
    jb .capital_letter

    # checks if lower case
    # makes 'a' the new zero, 32 = DEC('a' - 'A')
    subb $32, %dl
    # compares with z's dec value - 'a' dec value
    cmpb $25, %dl 
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
    movq %rax, %r9
    movq %rdi, %r8
    movq %rsi, %rdi
    xorq %rax, %rax
    call pstrlen

.check_valid_length:
    # checks if i > j
    cmpq %rcx, %rdx
    ja .invalid_range

    # checks if j => source's length
    cmpq %rax, %rcx
    jae .invalid_range

    # checks if j => dest's length
    cmpq %r9, %rcx
    jae .invalid_range

# loops through the strings range
.pstrijcpy_loop:
    # saves the source's string i's char in r10
    movb 1(%rax, %rdx, 1), %r10b

    # put the char in dest
    movb %r10b, 1(%r9, %rdx, 1)

    # increments to the next iteration
    incq %rdx
    cmpq %rcx, %rdx
    # jumps if i > j
    ja .pstrijcpy_exit
    jmp .pstrijcpy_loop

# in case the range is invalid prints what's needed
.invalid_range:
    movq invalid_range_message, %rdi
    movq %rax, %rax
    pushq %r8
    call printf

.pstrijcpy_exit:
    popq %rax
    movq %rbp, %rsp
    popq %rbp
    ret




.global pstrcmp
.type pstrcmp, @function
pstrcmp:
    # Enter
    pushq %rbp
    movq %rsp, %rbp

    # gets pstr1's length
    xorq %rax, %rax
    call pstrlen

    # gets pstr2's length
    movq %rax, %rdx
    xorq %rax, %rax
    movq %rdi, %rcx
    movq %rsi, %rdi
    call pstrlen
    movq %rcx, %rdi

    # right now:
    # rax = pstr2's length
    # rdx = pstr1's length
    # rdi points to pstr1
    # rsi points to pstr2

    # sets up the result to go to if the loop
    # that goes through the strings and compares them finishes
    # when both are equal until one of the strings end
    # (the loop runs the length of the shorter string)
    # when the first string is shorter then,
    # it should go to the first being bigger when the loop ends and both are equal
    # otherwise it should go to the first being smaller
    # when lengths are equal it goes to them being equal
    cmpq %rax, %rdx
    xorq %r8, %r8
    ja .first_length_bigger
    jb .first_length_smaller

.length_equal:
    movq %rax, %rcx
    pushq .both_equal
    jmp .pstrcmp_loop

.first_length_bigger:
    movq %rax, %rcx
    pushq .first_smaller
    jmp .pstrcmp_loop

.first_length_smaller:
    movq %rdx, %rcx
    pushq .first_bigger
    jmp .pstrcmp_loop

# runs rcx times (the counter is saved on r8), and goes through the strings together
.pstrcmp_loop:
    # pstr1's r8's char
    movb 1(%rdi, %r8, 1),%r9b
    # pstr2's r8's char
    movb 1(%rsi, %r8, 1),%r10b

    cmp %r10b, %r9b
    jb .first_smaller
    ja .first_bigger

    # iterates to the next iteration
    incq %r8
    cmp %rcx, %r8
    jb .pstrcmp_loop

    # ends loop and decides by the shorter string
    popq %rax
    jmp *%rax

.first_smaller:
    # returns -1
    movl $-1, %eax
    movq %rbp, %rsp
    popq %rbp
    ret

.first_bigger:
    # returns 1
    movl $1, %eax
    movq %rbp, %rsp
    popq %rbp
    ret

.both_equal:
    # returns 0
    xorq %rax, %rax
    movq %rbp, %rsp
    popq %rbp
    ret



.global pstrrev
.type pstrrev, @function
pstrrev:
    # enter
    pushq %rbp
    movq %rsp, %rbp

    # gets the pstr's length
    # (pointer to it already in rdi)
    xorq %rax, %rax
    call pstrlen
    # rax = length

    # sets the counter for the loop that goes through the string to 0
    xorq %rcx, %rcx

# goes through the string and pushes each char to the stack
.pstrrev_first_loop:
    # gets the next char and stores it in rdx
    # then pushes it to the stack
    xorq %rdx, %rdx
    movb 1(%rdi, %rcx, 1), %dl
    decq %rsp
    movb %dl, (%rsp)

    # goes the next iteration
    incq %rcx
    cmp %rax, %rcx
    jb .pstrrev_first_loop
    
    xorq %rcx, %rcx

# goes throug the string and pops each char from the stack and puts in the string
.pstrrev_second_loop:
    # saves the next char address in rdx
    leaq 1(%rdi, %rcx, 1), %rdx

    # pops the next char from the stack and puts it in the string
    movb (%rsp), %sil
    incq %rsp
    movb %sil, (%rdx)

    # goes through the next iteration
    incq %rcx
    cmp %rax, %rcx
    jb .pstrrev_second_loop

# exits
.exit:
    # puts the pointer in rax
    movq %rdi, %rax
    movq %rbp, %rsp
    popq %rbp
    ret

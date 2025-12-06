    .text
    .globl  main
main:
    addi    x2, x2, -32
    sw      x8, 0(x2)
    sw      x9, 4(x2)
    sw      x18, 8(x2)
    sw      x19, 12(x2)
    sw      x20, 16(x2)

    addi    x20, x2, 0

    # Initialize disk positions 
    sw      x0, 20(x2)
    sw      x0, 24(x2)
    sw      x0, 28(x2)

    addi    x8, x0, 1
game_loop:

    addi    x5, x0, 8
    beq     x8, x5, finish_game

    srli    x5, x8, 1
    xor     x6, x8, x5

    # Calculate gray(n-1)
    addi    x7, x8, -1
    srli    x28, x7, 1
    xor     x7, x7, x28

    xor     x5, x6, x7

    # Determine disk number 
    addi    x9, x0, 0
    andi    x6, x5, 1
    bne     x6, x0, disk_found

    addi    x9, x0, 1
    andi    x6, x5, 2
    bne     x6, x0, disk_found

    addi    x9, x0, 2

disk_found:
    # Load current disk position 
    slli    x5, x9, 2
    addi    x5, x5, 20
    add     x5, x20, x5
    lw      x18, 0(x5)

    bne     x9, x0, handle_large

    addi    x19, x18, 2
    addi    x6, x0, 3
    blt     x19, x6, display_move
    sub     x19, x19, x6
    jal     x0, display_move

handle_large:
    lw      x6, 20(x20)
    addi    x19, x0, 3
    sub     x19, x19, x18
    sub     x19, x19, x6

display_move:
    # Print "Move Disk "
    li      a0, 1
    la      a1, str1
    li      a2, 10
    li      a7, 64
    ecall
    
    # Print disk number 
    addi    t0, x9, 49
    la      a1, numbuf
    sb      t0, 0(a1)
    li      a0, 1
    li      a2, 1
    li      a7, 64
    ecall
    
    # Print " from "
    li      a0, 1
    la      a1, str2
    li      a2, 6
    li      a7, 64
    ecall
    
    # Print A, B, or C
    la      a1, pegs
    add     a1, a1, x18
    li      a0, 1
    li      a2, 1
    li      a7, 64
    ecall
    
    # Print " to "
    li      a0, 1
    la      a1, str3
    li      a2, 4
    li      a7, 64
    ecall
    
    # Print A, B, or C
    la      a1, pegs
    add     a1, a1, x19
    li      a0, 1
    li      a2, 1
    li      a7, 64
    ecall
    
    # Print newline
    li      t0, 10
    la      a1, numbuf
    sb      t0, 0(a1)
    li      a0, 1
    li      a2, 1
    li      a7, 64
    ecall

    # Update disk position 
    slli    x5, x9, 2
    addi    x5, x5, 20
    add     x5, x20, x5
    sw      x19, 0(x5)

    # Increment counter and loop
    addi    x8, x8, 1
    jal     x0, game_loop

finish_game:
    lw      x8, 0(x2)
    lw      x9, 4(x2)
    lw      x18, 8(x2)
    lw      x19, 12(x2)
    lw      x20, 16(x2)
    addi    x2, x2, 32
    li      a7, 93
    ecall

    .data
pegs:       .ascii  "ABC"
str1:       .asciz  "Move Disk "
str2:       .asciz  " from "
str3:       .asciz  " to "
numbuf:     .byte   0

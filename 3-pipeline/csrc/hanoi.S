.globl _start
_start:
    li      sp, 0x120
    addi    sp, sp, -32
    sw      s0, 0(sp)
    sw      s1, 4(sp)
    sw      s2, 8(sp)
    sw      s3, 12(sp)
    sw      s4, 16(sp)
    sw      s5, 20(sp)

    li      s4, 0x80
    sw      zero, 0(s4)
    sw      zero, 4(s4)
    sw      zero, 8(s4)

    li      s0, 1
    li      s5, 8

game_loop:
    li      t0, 8
    beq     s0, t0, finish_game

    srli    t0, s0, 1
    xor     t1, s0, t0

    addi    t2, s0, -1
    srli    t3, t2, 1
    xor     t2, t2, t3

    xor     t0, t1, t2

    li      s1, 0
    andi    t3, t0, 1
    bne     t3, zero, disk_found

    li      s1, 1
    andi    t3, t0, 2
    bne     t3, zero, disk_found

    li      s1, 2

disk_found:
    slli    t0, s1, 2
    add     t0, s4, t0
    lw      s2, 0(t0)

    bne     s1, zero, handle_large_disk

    addi    s3, s2, 2
    li      t3, 3
    blt     s3, t3, calc_dest_done
    sub     s3, s3, t3
    j       calc_dest_done

handle_large_disk:
    lw      t3, 0(s4)
    li      s3, 3
    sub     s3, s3, s2
    sub     s3, s3, t3

calc_dest_done:
    sw      s1, 0(s5)
    sw      s2, 4(s5)
    sw      s3, 8(s5)
    addi    s5, s5, 12

    slli    t0, s1, 2
    add     t0, s4, t0
    sw      s3, 0(t0)

    addi    s0, s0, 1
    j       game_loop

finish_game:
    addi    t0, s0, -1
    sw      t0, 4(zero)

    lw      t0, 0(s4)
    lw      t1, 4(s4)
    lw      t2, 8(s4)
    
    li      t3, 0x90
    sw      t0, 0(t3)
    sw      t1, 4(t3)
    sw      t2, 8(t3)

    lw      s0, 0(sp)
    lw      s1, 4(sp)
    lw      s2, 8(sp)
    lw      s3, 12(sp)
    lw      s4, 16(sp)
    lw      s5, 20(sp)
    addi    sp, sp, 32

end_loop:
    j       end_loop

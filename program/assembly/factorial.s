j main
#factorial(n = a1)
factorial:
    addi sp, sp, -16
    sw   ra, 12(sp)
    sw   s0, 8 (sp)
    beqz a1, basecase
    
    mv   s0, a1
    addi a1, a1, -1
    call factorial
    mul  s0, s0, a0
    mv   a0, s0
    j done
    basecase:
        li   a0, 1
        j done
    done:
        lw   ra, 12(sp)
        mv   a0, s0
        lw   s0, 8(sp)
        addi sp, sp, 16
        ret
main:
    li a1, 5
    call factorial
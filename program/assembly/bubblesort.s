j main
bubbleSort:  #(a1 = n)
    addi sp, sp, -16
    sw   ra, 12(sp)

    li   t0, 0                # t0 = i = 0
    addi t1, a1, -1           # t1 = n - 1
    li   t2, 0                # &array
    outerloop:
        bge  t0, t1, outerloop_end
        li   t3, 0             # j = 0
        sub  t4, t1, t0        # t4 = n - i - 1
        slli t4, t4, 2
        innerloop:
            bge  t3, t4, innerloop_end
            add  t5, t2, t3   # t5 = &array[j]
            addi t6, t5, 4    # t6 = &array[j + 1]
            lw   s0, 0(t5)    # s0 = array [j]
            lw   s1, 0(t6)    # s1 = array [j + 1]
            bgt  s0, s1, swap
            j done
            swap:
                sw s1, 0(t5)
                sw s0, 0(t6)
            done:
            addi t3, t3, 4    # j = j + 4
            j innerloop
        innerloop_end:
            addi t0, t0, 1    # i = i + 1
            j outerloop
    outerloop_end:
        lw   ra, 12(sp)
        addi sp, sp, 16
        ret
main:
    li a1, 256
    call bubbleSort
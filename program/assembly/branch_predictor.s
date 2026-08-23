# -----------------------------------------
# TEST 1: Always Taken
# Expected pattern: T T T T T ...
# -----------------------------------------

    addi x1, x0, 0
    addi x2, x0, 10

loop_taken:
    addi x1, x1, 1
    bne  x1, x2, loop_taken

end_taken:
    addi x3, x0, 1

# -----------------------------------------
# TEST 2: Always Not Taken
# Expected pattern: NT NT NT 
# -----------------------------------------
    addi x4, x0, 10
    addi x5, x0, 20

not_taken_test:
    beq  x4, x5, not_taken_target   # N
    addi x6, x6, 1
    beq  x4, x5, not_taken_target   # N
    addi x6, x6, 1
    beq  x4, x5, not_taken_target   # N

not_taken_target:

# -----------------------------------------
# TEST 3: Loop
# -----------------------------------------

    addi x7, x0, 0
    addi x8, x0, 20

loop:
    addi x7,x7,1

    bne  x7, x8, loop

    addi x3, x0, 123
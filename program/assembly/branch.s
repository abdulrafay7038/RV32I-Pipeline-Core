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


# -----------------------------------------
# TEST 4: RAW dependency immediately before branch
#
# Branch depends directly on result of ADDI.
#
# Expected:
# x9  = 5
# x10 = 5
# x11 = 1
#
# Branch should be TAKEN.
# -----------------------------------------

    addi x9,  x0, 4
    addi x9,  x9, 1

    addi x10, x0, 5

    beq  x9, x10, raw_taken

    addi x11, x0, 999       # Should NOT execute

raw_taken:
    addi x11, x0, 1


# -----------------------------------------
# TEST 5: RAW dependency causing NOT TAKEN
#
# x12 becomes 7 immediately before branch.
# x13 = 10.
#
# Expected:
# x14 = 1
# -----------------------------------------

    addi x12, x0, 3
    addi x12, x12, 4

    addi x13, x0, 10

    beq  x12, x13, raw_nt_target

    addi x14, x0, 1
    j    raw_nt_done

raw_nt_target:
    addi x14, x0, 999

raw_nt_done:


# -----------------------------------------
# TEST 6: Branch after multiple RAW dependencies
#
# x15 depends on x16
# x17 depends on x18
# Branch uses both.
#
# Expected:
# x19 = 1
# -----------------------------------------

    addi x16, x0, 20
    addi x15, x16, 5

    addi x18, x0, 25
    addi x17, x18, 0

    beq  x15, x17, multi_raw_taken

    addi x19, x0, 999
    j    multi_raw_done

multi_raw_taken:
    addi x19, x0, 1

multi_raw_done:


# -----------------------------------------
# TEST 7: LOAD -> BRANCH dependency
#
# Store a known value, load it, immediately
# use it in a branch.
#
# Expected:
# x22 = 1
#
# Memory location: 100
# -----------------------------------------

    addi x20, x0, 55
    addi x21, x0, 100

    sw   x20, 0(x21)

    lw   x22, 0(x21)

    addi x23, x0, 55

    beq  x22, x23, load_branch_taken

    addi x24, x0, 999
    j    load_branch_done

load_branch_taken:
    addi x22, x0, 1

load_branch_done:


# -----------------------------------------
# TEST 8: LOAD -> NOT TAKEN BRANCH
#
# Memory location: 104
# Stored value = 10
# Compare against 20.
#
# Expected:
# x26 = 1
# -----------------------------------------

    addi x25, x0, 10
    addi x27, x0, 104

    sw   x25, 0(x27)

    lw   x25, 0(x27)

    addi x28, x0, 20

    beq  x25, x28, load_nt_target

    addi x26, x0, 1
    j    load_nt_done

load_nt_target:
    addi x26, x0, 999

load_nt_done:


# -----------------------------------------
# TEST 9: STORE -> LOAD -> BRANCH
#
# Tests memory + load-use + branch.
#
# Memory location: 108
#
# Expected:
# x29 = 1
# -----------------------------------------

    addi x30, x0, 77
    addi x31, x0, 108

    sw   x30, 0(x31)
    lw   x30, 0(x31)

    addi x29, x0, 77

    beq  x30, x29, store_load_taken

    addi x29, x0, 999
    j    store_load_done

store_load_taken:
    addi x29, x0, 1

store_load_done:


# -----------------------------------------
# TEST 10: Branch followed by Jump
#
# If branch is NOT taken, JAL redirects
# execution back to another location.
#
# Expected:
# x3 = 10
# -----------------------------------------

    addi x1, x0, 5
    addi x2, x0, 10

    beq  x1, x2, branch_jump_target

    jal  x0, branch_jump_continue

branch_jump_target:
    addi x3, x0, 999

branch_jump_continue:
    addi x3, x0, 10


# -----------------------------------------
# TEST 11: Branch -> Jump -> Branch
#
# Stress control-flow redirection.
#
# Expected:
# x4 = 1
# x5 = 2
# -----------------------------------------

    addi x4, x0, 0
    addi x5, x0, 0

    beq  x4, x5, first_branch_taken

    addi x4, x0, 999
    j    first_branch_done

first_branch_taken:
    addi x4, x0, 1

first_branch_done:
    addi x5, x0, 2

    beq  x4, x5, second_branch_target

    addi x5, x0, 3
    j    second_branch_done

second_branch_target:
    addi x5, x0, 999

second_branch_done:


# -----------------------------------------
# TEST 12: Alternating branch behavior
#
# This is particularly useful for a 2-bit predictor.
#
# Pattern is approximately:
#
# T NT T NT T NT ...
#
# A 2-bit predictor struggles with this.
#
# Expected:
# x6 = 5
# -----------------------------------------

    addi x6, x0, 0
    addi x7, x0, 0
    addi x8, x0, 10

alternate_loop:

    addi x7, x7, 1

    # x7 parity determines branch behavior
    andi x9, x7, 1

    beq  x9, x0, alternate_nt

    # Taken path
    addi x6, x6, 1

alternate_nt:
    bne  x7, x8, alternate_loop


# -----------------------------------------
# TEST 13: Long NT history followed by T
#
# Very useful for testing 2-bit counter recovery.
#
# Expected branch pattern:
#
# NT NT NT NT NT NT NT NT NT T
#
# Expected:
# x10 = 1
# -----------------------------------------

    addi x10, x0, 0
    addi x11, x0, 0
    addi x12, x0, 10

long_nt_loop:

    addi x11, x11, 1

    beq  x11, x12, long_nt_taken

    j    long_nt_loop

long_nt_taken:
    addi x10, x0, 1


# -----------------------------------------
# TEST 14: Long T history followed by NT
#
# Branch pattern:
#
# T T T T T T T T T NT
#
# This tests recovery in the opposite direction.
#
# Expected:
# x13 = 1
# -----------------------------------------

    addi x14, x0, 0
    addi x15, x0, 10
    addi x13, x0, 0

long_t_loop:

    addi x14, x14, 1

    bne  x14, x15, long_t_loop

    # This instruction is reached after
    # the final branch becomes NOT TAKEN.
    addi x13, x0, 1


# -----------------------------------------
# TEST 15: Same target, different branches
#
# Multiple static branch PCs target the same
# destination.
#
# This can expose BTB indexing/tag bugs.
#
# Expected:
# x16 = 0
# -----------------------------------------

    addi x16, x0, 0
    addi x17, x0, 1

    beq  x16, x17, common_target

    addi x18, x0, 1

    beq  x16, x17, common_target

    addi x18, x0, 2

    j    common_done

common_target:
    addi x16, x0, 1

common_done:


# -----------------------------------------
# TEST 16: Same BHT index pressure
#
# Branches at different PCs may map to
# the same BHT index.
#
# Useful for detecting aliasing.
#
# Expected:
# x19 = 1
# x20 = 1
# -----------------------------------------

    addi x19, x0, 0
    addi x20, x0, 0

    # Branch A: taken
    addi x21, x0, 1
    beq  x21, x21, alias_taken

    addi x19, x0, 999

alias_taken:
    addi x19, x0, 1

    # Branch B: not taken
    addi x22, x0, 1
    addi x23, x0, 2

    beq  x22, x23, alias_nt

    addi x20, x0, 1
    j    alias_done

alias_nt:
    addi x20, x0, 999

alias_done:


# -----------------------------------------
# TEST 17: Branch immediately after branch
#
# Consecutive control-flow instructions.
#
# Expected:
# x24 = 1
# -----------------------------------------

    addi x25, x0, 1
    addi x26, x0, 1

    beq  x25, x26, consecutive_1

    addi x24, x0, 999

consecutive_1:

    beq  x25, x26, consecutive_2

    addi x24, x0, 999

consecutive_2:
    addi x24, x0, 1


# -----------------------------------------
# TEST 18: Branch depends on arithmetic result
#
# Tests ALU -> branch forwarding/hazard.
#
# Expected:
# x27 = 1
# -----------------------------------------

    addi x28, x0, 10
    addi x29, x0, 20

    add  x30, x28, x29
    addi x31, x0, 30

    beq  x30, x31, alu_branch_taken

    addi x27, x0, 999
    j    alu_branch_done

alu_branch_taken:
    addi x27, x0, 1

alu_branch_done:


# -----------------------------------------
# TEST 19: Branch depends on SUB result
#
# Expected:
# x28 = 1
# -----------------------------------------

    addi x29, x0, 50
    addi x30, x0, 20

    sub  x31, x29, x30
    addi x27, x0, 30

    beq  x31, x27, sub_branch_taken

    addi x28, x0, 999
    j    sub_branch_done

sub_branch_taken:
    addi x28, x0, 1

sub_branch_done:


# -----------------------------------------
# TEST 20: Final signature
#
# Put known value into x30 so the testbench
# can easily determine that the complete
# program reached the end.
# -----------------------------------------

    addi x30, x0, 1234

end_of_branch_tests:
    nop
    nop
    nop    
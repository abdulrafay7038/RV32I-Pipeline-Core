# ============================================================
# Recursive Merge Sort - 256 elements
#
# Array:
#   base address = 0
#   elements     = 256
#   bytes        = 1024
#
# Temporary merge buffer:
#   base address = 1024
#
# Calling convention:
#   a0 = base address
#   a1 = left index
#   a2 = right index
#
# ============================================================


        # Initialize stack


        # a0 = array base
        addi a0, x0, 0

        # a1 = left = 0
        addi a1, x0, 0

        # a2 = right = 255
        addi a2, x0, 255

        # Call merge_sort
        jal  ra, merge_sort

        jal  x0, done


# ============================================================
# merge_sort(a0, a1, a2)
#
# a0 = base
# a1 = left
# a2 = right
#
# if left >= right:
#     return
#
# mid = (left + right) / 2
#
# merge_sort(left, mid)
# merge_sort(mid+1, right)
# merge(left, mid, right)
# ============================================================

merge_sort:

        # Stack frame

        addi sp, sp, -20

        sw   ra, 16(sp)
        sw   a1, 12(sp)
        sw   a2, 8(sp)
        sw   s0, 4(sp)
        sw   s1, 0(sp)

        # if left >= right return

        bge  a1, a2, merge_sort_return

        # mid = (left + right) / 2

        add  s0, a1, a2
        srli s0, s0, 1

        # merge_sort(left, mid)

        addi a2, s0, 0
        jal  ra, merge_sort

        # merge_sort(mid+1, right)

        lw   a1, 12(sp)
        lw   a2, 8(sp)

        addi a1, s0, 1

        jal  ra, merge_sort

        # merge(left, mid, right)

        lw   a1, 12(sp)
        lw   a2, 8(sp)

        addi a3, s0, 0

        jal  ra, merge

merge_sort_return:

        # Restore registers

        lw   s1, 0(sp)
        lw   s0, 4(sp)
        lw   a2, 8(sp)
        lw   a1, 12(sp)
        lw   ra, 16(sp)

        addi sp, sp, 20

        jalr x0, 0(ra)


# ============================================================
# merge
#
# a0 = array base
# a1 = left
# a2 = right
# a3 = mid
#
# Merge:
#
# [left ... mid] and [mid+1 ... right]
#
# Temporary buffer starts at address 1024.
# ============================================================

merge:

        addi sp, sp, -28

        sw   ra, 24(sp)
        sw   a1, 20(sp)
        sw   a2, 16(sp)
        sw   a3, 12(sp)
        sw   s0, 8(sp)
        sw   s1, 4(sp)
        sw   s2, 0(sp)

        # i = left
        addi s0, a1, 0

        # j = mid + 1
        addi s1, a3, 1

        # k = left
        addi s2, a1, 0


# ============================================================
# Compare elements from left and right halves
# ============================================================

merge_compare:

        # if i > mid
        bgt  s0, a3, copy_right

        # if j > right
        bgt  s1, a2, copy_left

        # Load array[i]

        slli t0, s0, 2
        add  t0, a0, t0
        lw   t1, 0(t0)

        # Load array[j]

        slli t2, s1, 2
        add  t2, a0, t2
        lw   t3, 0(t2)

        # if array[i] <= array[j]
        ble  t1, t3, take_left

        # ----------------------------------------------------
        # Take right element
        # ----------------------------------------------------

        # temp[k] address = 1024 + k*4

        slli t4, s2, 2
        addi t5, t4, 1024

        add  t5, a0, t5

        sw   t3, 0(t5)

        addi s1, s1, 1
        addi s2, s2, 1

        jal  x0, merge_compare


# ============================================================
# Take left element
# ============================================================

take_left:

        slli t4, s2, 2
        addi t5, t4, 1024
        add  t5, a0, t5

        sw   t1, 0(t5)

        addi s0, s0, 1
        addi s2, s2, 1

        jal  x0, merge_compare


# ============================================================
# Copy remaining left half
# ============================================================

copy_left:

        bgt  s0, a3, copy_back

        slli t0, s0, 2
        add  t0, a0, t0

        lw   t1, 0(t0)

        slli t2, s2, 2
        addi t3, t2, 1024
        add  t3, a0, t3

        sw   t1, 0(t3)

        addi s0, s0, 1
        addi s2, s2, 1

        jal  x0, copy_left


# ============================================================
# Copy remaining right half
# ============================================================

copy_right:

        bgt  s1, a2, copy_back

        slli t0, s1, 2
        add  t0, a0, t0

        lw   t1, 0(t0)

        slli t2, s2, 2
        addi t3, t2, 1024
        add  t3, a0, t3

        sw   t1, 0(t3)

        addi s1, s1, 1
        addi s2, s2, 1

        jal  x0, copy_right


# ============================================================
# Copy temporary buffer back into array
# ============================================================

copy_back:

        # k = left

        lw   a1, 20(sp)
        lw   a2, 16(sp)

        addi s0, a1, 0

copy_back_loop:

        bgt  s0, a2, merge_return

        # temp[k]

        slli t0, s0, 2
        addi t1, t0, 1024
        add  t1, a0, t1

        lw   t2, 0(t1)

        # array[k]

        add  t3, a0, t0

        sw   t2, 0(t3)

        addi s0, s0, 1

        jal  x0, copy_back_loop


# ============================================================
# Return from merge
# ============================================================

merge_return:

        lw   s2, 0(sp)
        lw   s1, 4(sp)
        lw   s0, 8(sp)

        lw   a3, 12(sp)
        lw   a2, 16(sp)
        lw   a1, 20(sp)

        lw   ra, 24(sp)

        addi sp, sp, 28

        jalr x0, 0(ra)
done:

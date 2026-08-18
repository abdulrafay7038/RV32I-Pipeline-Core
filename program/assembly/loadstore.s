# DMEM HARD-CASE TEST


addi x1, x0, 0x100          # x1 = base address 0x100

# 1. Store known word patterns

lui  x2, 0x12345             # x2 = 0x12345000
addi x2, x2, 0x678            # x2 = 0x12345678

sw   x2, 0(x1)               # mem[0x100] = 0x12345678

lui  x3, 0xFFFFF
addi x3, x3, 0x800            # x3 = 0xFFFFF800

sw   x3, 4(x1)               # mem[0x104] = 0xFFFFF800



# 2. Test LB / LBU on EVERY byte of 0x12345678


lb   x4, 0(x1)               # 0x00000078
lb   x5, 1(x1)               # 0x00000056
lb   x6, 2(x1)               # 0x00000034
lb   x7, 3(x1)               # 0x00000012

lbu  x8, 0(x1)               # 0x00000078
lbu  x9, 1(x1)               # 0x00000056
lbu  x10, 2(x1)              # 0x00000034
lbu  x11, 3(x1)              # 0x00000012


# 3. Test SH / LH / LHU


lui  x12, 0xABCD0
addi x12, x12, 0x123         # x12 = 0xABCD0123

sh   x12, 0(x1)              # mem[0x100] lower half = 0x0123
sh   x12, 2(x1)              # mem[0x100] upper half = 0x0123

lh   x13, 0(x1)              # should = 0x00000123
lh   x14, 2(x1)              # should = 0x00000123

lhu  x15, 0(x1)              # should = 0x00000123
lhu  x16, 2(x1)              # should = 0x00000123



# 4. SB at ALL FOUR BYTE LANES

addi x17, x0, 0x11
sb   x17, 0(x1)

addi x17, x0, 0x22
sb   x17, 1(x1)

addi x17, x0, 0x33
sb   x17, 2(x1)

addi x17, x0, 0x44
sb   x17, 3(x1)

# Expected:
# mem[0x100] = 0x44332211

lw   x18, 0(x1)              # should = 0x44332211



# 5. SIGN EXTENSION HARD CASE


addi x19, x0, -1
sb   x19, 0(x1)              # byte = FF

lb   x20, 0(x1)              # should = FFFFFFFF
lbu  x21, 0(x1)              # should = 000000FF



# 6. SIGNED HALFWORD HARD CASE


addi x22, x0, -32768
sh   x22, 2(x1)              # upper half = 8000

lh   x23, 2(x1)              # should = FFFF8000
lhu  x24, 2(x1)              # should = 00008000


# 7. OVERLAPPING STORES

lui  x25, 0xDEADB
addi x25, x25, 0xEEF         # x25 = DEADBEEF

sw   x25, 8(x1)              # DEADBEEF

addi x26, x0, 0xAA
sb   x26, 9(x1)              # modify byte +1

lw   x27, 8(x1)
# Expected = DEADAAEF


# 8. Another overlapping halfword

addi x28, x0, 0x123
sh   x28, 10(x1)

lw   x29, 8(x1)
# Expected = 0123AAEF
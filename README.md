# RV32I Three-Stage Processor

A small, synthesizable SystemVerilog processor with a three-stage fetch, execute, and write pipeline. The core implements an RV32I integer subset and uses a dynamic branch predictor to choose fetch addresses.

![Datapath and controller](docs/datapath&controller_colored.drawio.png)

## Architecture

| Stage | Main work |
| --- | --- |
| Fetch | Read the instruction at the PC; use the branch predictor to select the next fetch address. |
| Execute | Decode the instruction, read operands, perform ALU operations, calculate branch/jump targets, and resolve branches. |
| Write | Access data memory for loads and stores, then write results to the register file. |

The branch predictor has a 256-entry branch history table with 2-bit saturating counters and a 256-entry branch target buffer. Mispredicted branches and jumps redirect fetch and flush the younger instruction.

## Implemented instructions

- Register ALU operations: `ADD`, `SUB`, `AND`, `OR`, `XOR`, `SLL`, `SRL`, `SRA`, `SLT`, and `SLTU`.
- Immediate ALU operations: `ADDI`, `ANDI`, `ORI`, `XORI`, `SLLI`, `SRLI`, `SRAI`, `SLTI`, and `SLTIU`.
- Loads and stores: `LB`, `LH`, `LW`, `LBU`, `LHU`, `SB`, `SH`, and `SW`.
- Conditional branches: `BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, and `BGEU`.
- Control flow: `JAL` and `JALR`.
- Upper immediates: `LUI` and `AUIPC`.

This is a non-privileged core. It does not implement privilege modes, CSRs, interrupts, or an exception/trap handler.

## Memories

- Instruction memory contains 2,048 32-bit words (8 KiB), addressed by byte PC.
- Data memory contains 4,096 bytes (4 KiB) and uses little-endian byte lanes.
- Instruction and data images are loaded by the testbenches from `program/machinecode/`.

## Repository layout

| Path | Contents |
| --- | --- |
| `rtl/` | Processor, memories, and branch predictor RTL. |
| `tb/` | SystemVerilog testbenches. |
| `program/assembly/` | Example assembly programs. |
| `program/machinecode/` | Hex instruction and data images used by the testbenches. |
| `docs/` | Datapath and controller diagrams. |

## Simulating with QuestaSim

Run these commands in PowerShell from the repository root. The simulator commands run from `questasim/` because the testbenches use paths relative to that directory.

```powershell
Set-Location questasim
vlib work
$rtlFiles = Get-ChildItem ..\rtl -Recurse -Filter *.sv | ForEach-Object FullName
$tbFiles = Get-ChildItem ..\tb -Recurse -Filter *.sv | ForEach-Object FullName
vlog -sv -work work @rtlFiles @tbFiles
```

Run the arithmetic, branch, load/store, and branch predictor tests with:

```powershell
foreach ($top in @('arithmetic_tb', 'branch_tb', 'loadstore_tb', 'Branch_Predictor_tb')) {
    vsim -c -lib work $top -do 'run -all; quit -f'
}
```

The factorial, bubble sort, and merge sort benches initialize the stack pointer through a hierarchical testbench write. With QuestaSim 2024.1, suppress its `vopt-7061` diagnostic for those runs:

```powershell
vsim -c -suppress 7061 -lib work factorial_tb -do 'run 4000; quit -f'
vsim -c -suppress 7061 -lib work bubblesort_tb -do 'run -all; quit -f'
vsim -c -suppress 7061 -lib work mergesort_tb -do 'run -all; quit -f'
```

`factorial_tb` checks the result after 3,000 simulation time units and has no `$finish`, so its command runs to 4,000 before exiting. The other benches finish themselves when their checks complete.

## Authors

- Abdul Rafay
- Haiqua Ghaffar

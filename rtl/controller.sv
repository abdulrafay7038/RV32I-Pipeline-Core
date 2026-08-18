module controller (
    input  logic [6:0] Op,          // instruction opcode
    input  logic [2:0] funct3,      // funct3 field for instruction decoding
    input  logic       funct7b5,    // instruction bit 30 for alu decoding
    input  logic       Zero,        // alu zero flag for branch decisions
    input  logic       Negative,    // alu sign flag for signed branch decisions
    input  logic       Overflow,    // alu overflow flag for signed branch decisions
    input  logic       Carry,       // alu carry flag for unsigned branch decisions

    output logic       Branch_taken,
    output logic       Jump,
    output logic [1:0] ResultSrc,   // select alu result or memory data
    output logic       MemWrite,    // data memory write enable
    output logic [1:0] PCSrc,       // select next PC source
    output logic [2:0] ALUSrc,      // select alu operand B source
    output logic       RegWrite,    // register write enable
    output logic [2:0] ImmSrc,      // immediate format selector
    output logic [3:0] AlUControl   // alu operation control
);

    logic [1:0] ALUOp;              // high-level alu operation control


    // main decoder: generates instruction-level control signals based on opcode
    // and determines the required alu operation type
    main_decoder MainDecoder(
        .Op(Op),
        .funct3(funct3),
        .Zero(Zero),
        .Negative(Negative),
        .Overflow(Overflow),
        .Carry(Carry),

        .Branch_taken(Branch_taken),
        .Jump(Jump),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .PCSrc(PCSrc),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUOp(ALUOp)
    );


    // alu decoder: Converts ALUOp and instruction function fields into a specific alu operation
    alu_decoder ALUDecoder(
        .ALUOp(ALUOp),
        .Op(Op),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .AlUControl(AlUControl)
    );

endmodule : controller

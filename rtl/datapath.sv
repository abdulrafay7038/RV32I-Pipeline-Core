module datapath (
    input  logic       CLK,
    input  logic       RST,
    input  logic [1:0] PCSrcE,       // select next PC: PC+4 or branch/jump target
    input  logic       RegWriteE,    // register file write enable
    input  logic [2:0] ImmSrcE,      // immediate type selector
    input  logic [2:0] ALUSrcE,      // select alu operand B: register or immediate
    input  logic [3:0] AlUControlE,  // alu operation control
    input  logic       MemWriteE,    // data memory write enable
    input  logic [1:0] ResultSrcE,   // select write-back data: alu result or memory data
    input logic Branch_taken, JumpE,

    output logic [6:0] Op,          // opcode field sent to controller
    output logic [2:0] funct3,      // funct3 field sent to controller
    output logic       funct7b5,    // bit 30 of instruction (used for alu decoding)
    output logic       Zero,        // zero flag from alu (used for branches)
    output logic       Negative,    // alu sign flag (used for signed branches)
    output logic       Overflow,    // alu overflow flag (used for signed branches)
    output logic       Carry        // alu carry flag (used for unsigned branches)
);

    // internal datapath signals for FETCH
    logic [31:0] PCF;
    logic [31:0] InstrF;
    logic [31:0] PCPlus4F;
    logic [31:0] PCNextF;

    // internal datapath signals for EXECUTE
    logic [31:0] InstrE;
    logic [31:0] PCE;
    logic [31:0] PCPlus4E;
    logic [31:0] ALUResultE, ImmExtE;
    logic [31:0] PCTargetE;
    logic [4:0]  RS1E, RS2E;
    logic [31:0] RD1E, RD2E;
    logic [31:0] SrcA, SrcB;

    // internal datapath signals for WRITE
    logic [31:0] ALUResultW;
    logic [31:0] RD2W;
    logic [4:0]  RDW;
    logic [31:0] PCPlus4W;
    logic [1:0] ResultSrcW;
    logic RegWriteW;
    logic MemWriteW;
    logic [31:0] ResultW;
    logic [31:0] ReadDataW;
    logic [31:0] MRD,MWD;
    logic [2:0] funct3W;
    logic [3:0] WBE;
    logic FlushE;       // Flush Execute reg
    assign FlushE = Branch_taken || JumpE;

    // PC + 4 calculation
    assign PCPlus4F = PCF + 4;
    // branch/jump target address calculation
    assign PCTargetE = PCE + ImmExtE;

    // program Counter register
    pc ProgramCounter (
        .CLK(CLK),
        .RST(RST),
        .PCNext(PCNextF),
        .PC(PCF)
    );

    // instruction memory
    instr_mem InstrMem (
        .A(PCF),
        .RD(InstrF)
    );

    //FETCH-EXECUTE Register
    always_ff @(posedge CLK) begin
    if (RST || FlushE) begin
        InstrE   <= 32'h00000013;
        PCE      <= 32'b0;
        PCPlus4E <= 32'b0;
    end
    else begin
        InstrE   <= InstrF;
        PCE      <= PCF;
        PCPlus4E <= PCPlus4F;
    end
    end

    assign RS1E = InstrE[19:15];
    assign RS2E = InstrE[24:20];
    // register file
    regfile Regfile (
        .CLK(CLK),
        .RST(RST),
        .A1(RS1E),               // rs1
        .A2(RS2E),              // rs2
        .A3(RDW),              // rd
        .WD3(ResultW),        // write back data
        .WE3(RegWriteW),
        .RD1(RD1E),
        .RD2(RD2E)
    );

    // arithmetic logic unit
    alu ALU (
        .SrcA(SrcA),
        .SrcB(SrcB),
        .AlUControl(AlUControlE),
        .ALUResult(ALUResultE),
        .Zero(Zero),
        .Negative(Negative),
        .Overflow(Overflow),
        .Carry(Carry)
    );


    // immediate value generator
    extend Extend (
        .Instr(InstrE),
        .ImmSrc(ImmSrcE),
        .ImmExt(ImmExtE)
    );

     //EXECUTE-WRITE Register
    always_ff @(posedge CLK) begin
        if (RST) begin
            ResultSrcW <= '0;
            MemWriteW  <= '0;
            RegWriteW  <= '0;

            ALUResultW <= '0;
            RD2W       <= '0;
            PCPlus4W   <= '0;
            RDW        <= '0;
            funct3W     <= '0;
        end
        else begin
            ResultSrcW <= ResultSrcE;
            MemWriteW  <= MemWriteE;
            RegWriteW  <= RegWriteE;

            ALUResultW <= ALUResultE;
            RD2W       <= RD2E;
            PCPlus4W   <= PCPlus4E;
            RDW        <= InstrE[11:7];
            funct3W     <= funct3;
        end
    end
    lsu LoadStoreUnit(
        .func3(funct3W),
        .ALUResult(ALUResultW),
        .WD(RD2W),
        .MRD(MRD),
        .WBE(WBE),
        .RD(ReadDataW),
        .MWD(MWD)

    );
    data_mem DataMem (
        .CLK(CLK),
        .A({ALUResultW[31:2],2'b00}),
        .WE(MemWriteW),
        .WBE(WBE),
        .WD(MWD),
        .RD(MRD)
    );

    // ALU operand B selection
    assign SrcB   = ALUSrcE[2] ? ImmExtE   : RD2E;
    always_comb begin
        // Next PC selection
        case(PCSrcE)
            2'b00: PCNextF = PCPlus4F;
            2'b01: PCNextF = PCTargetE;
            2'b10: PCNextF = ALUResultE;
            default: PCNextF = PCPlus4F;
        endcase
        // ALU operand A selection
        case(ALUSrcE[1:0])
            2'b00:   SrcA = RD1E;
            2'b01:   SrcA = 32'b0;
            2'b10:   SrcA = PCE;
            default: SrcA = RD1E;
        endcase
        // write back data selection
        case(ResultSrcW)
            2'b00:   ResultW = ALUResultW;
            2'b01:   ResultW = ReadDataW;
            2'b10:   ResultW = PCPlus4W;
            default: ResultW = ALUResultW;
        endcase
    end

    // instruction fields forwarded to the controller
    assign Op       = InstrE[6:0];
    assign funct3   = InstrE[14:12];
    assign funct7b5 = InstrE[30];

endmodule : datapath
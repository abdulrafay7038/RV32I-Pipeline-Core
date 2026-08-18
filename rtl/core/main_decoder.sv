module main_decoder (
    input  logic [6:0] Op,
    input  logic [2:0] funct3,
    input  logic       Zero,
    input  logic       Negative,
    input  logic       Overflow,
    input  logic       Carry,

    output logic Branch_taken, Jump, 
    output logic [1:0] ResultSrc,
    output logic       MemWrite,
    output logic [1:0] PCSrc,
    output logic [2:0] ALUSrc,
    output logic       RegWrite,
    output logic [2:0] ImmSrc,
    output logic [1:0] ALUOp
);

typedef enum logic [6:0] {
    OP_LOAD    = 7'b0000011,
    OP_IMM     = 7'b0010011,
    OP_AUIPC   = 7'b0010111,
    OP_STORE   = 7'b0100011,
    OP_REG     = 7'b0110011,
    OP_LUI     = 7'b0110111,
    OP_BRANCH  = 7'b1100011,
    OP_JALR    = 7'b1100111,
    OP_JAL     = 7'b1101111,
    OP_SYSTEM  = 7'b1110011
} opcode_t;

opcode_t Opcode;
assign Opcode = opcode_t'(Op);
always_comb begin
    // default values
    RegWrite  = 1'b0;
    ImmSrc    = 3'b000;
    ALUSrc    = 3'b000;
    PCSrc     = 2'b00;
    MemWrite  = 1'b0;
    ResultSrc = 2'b00;
    ALUOp     = 2'b00;
    Jump      = 0;
    Branch_taken = 0;
    case (Opcode)

        // R-type
        OP_REG: begin
            RegWrite = 1'b1;
            ALUOp    = 2'b10;
        end

        // I-type ALU
        OP_IMM: begin
            RegWrite = 1'b1;
            ALUSrc   = 3'b100;
            ALUOp    = 2'b10;
        end

        // JALR
        OP_JALR: begin
            RegWrite = 1'b1;
            ALUSrc   = 3'b100;
            PCSrc    = 2'b10;
            ALUOp    = 2'b10;
            ResultSrc = 2'b10;
            Jump = 1;
        end

        // LOAD
        OP_LOAD: begin
            RegWrite  = 1'b1;
            ALUSrc    = 3'b100;
            ResultSrc = 2'b01;
            ALUOp     = 2'b00;
        end

        // STORE
        OP_STORE: begin
            ImmSrc   = 3'b001;
            ALUSrc   = 3'b100;
            MemWrite = 1'b1;
            ALUOp    = 2'b00;
        end

        // B-type
        OP_BRANCH: begin
            ImmSrc = 3'b010;
            ALUOp  = 2'b01;

            case (funct3)
                3'b000:  PCSrc = Zero                   ? 2'b01 : 2'b00;  // BEQ
                3'b001:  PCSrc = !Zero                  ? 2'b01 : 2'b00;  // BNE
                3'b100:  PCSrc = (Negative ^ Overflow)  ? 2'b01 : 2'b00;  // BLT
                3'b101:  PCSrc = !(Negative ^ Overflow) ? 2'b01 : 2'b00;  // BGE
                3'b110:  PCSrc = !Carry                 ? 2'b01 : 2'b00;  // BLTU
                3'b111:  PCSrc = Carry                   ? 2'b01 : 2'b00; // BGEU
                default: PCSrc = 2'b00;
            endcase
            Branch_taken = PCSrc[0];
        end

        // JAL
        OP_JAL: begin
            RegWrite = 1'b1;
            ImmSrc   = 3'b011;
            PCSrc    = 2'b01;
            ResultSrc = 2'b10;
            Jump = 1;
        end

        // LUI
        OP_LUI: begin
            RegWrite = 1'b1;
            ImmSrc   = 3'b100;
            ALUSrc   = 3'b101;
            ALUOp    = 2'b00;
        end

        // AUIPC
        OP_AUIPC: begin
            RegWrite = 1'b1;
            ImmSrc   = 3'b100;
            ALUSrc   = 3'b110;
            ALUOp    = 2'b00;
        end

        default: begin
            // defaults already assigned
        end

    endcase
end

endmodule : main_decoder

module alu_decoder (
    input  logic [1:0] ALUOp,
    input  logic [6:0] Op,
    input  logic [2:0] funct3,
    input  logic       funct7b5,

    output logic [3:0] AlUControl
);

always_comb begin
    case (ALUOp)
        // load/store
        2'b00:
            AlUControl = 4'b0010;
        // branches
        2'b01: begin
            case(funct3)
                3'b000, 3'b001: AlUControl = 4'b0110;                                       // SUB for BEQ/BNE
                3'b100, 3'b101: AlUControl = 4'b0111;                                       // SLT signed
                3'b110, 3'b111: AlUControl = 4'b0011;                                       // SLTU unsigned
                default:        AlUControl = 4'b0110;
            endcase
        end

        // R/I instructions
        2'b10: begin
            case (funct3)
                3'b000:  AlUControl = (Op == 7'b0110011 && funct7b5) ? 4'b0110 : 4'b0010;   // SUB : ADD
                3'b001:  AlUControl = 4'b1000;                                              // SLL
                3'b010:  AlUControl = 4'b0111;                                              // SLT
                3'b011:  AlUControl = 4'b0011;                                              // SLTU
                3'b100:  AlUControl = 4'b1001;                                              // XOR
                3'b101:  AlUControl = funct7b5 ? 4'b1011 : 4'b1010;                         // SRA : SRL
                3'b110:  AlUControl = 4'b0001;                                              // OR
                3'b111:  AlUControl = 4'b0000;                                              // AND
                default: AlUControl = 4'b0010;
            endcase
        end

        default: AlUControl = 4'b0010;
    endcase
end

endmodule: alu_decoder

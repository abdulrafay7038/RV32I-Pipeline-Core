module alu (
    input  logic [31:0] SrcA,
    input  logic [31:0] SrcB,
    input  logic [3:0]  AlUControl,

    output logic [31:0] ALUResult,
    output logic        Zero,
    output logic        Negative,
    output logic        Overflow,
    output logic        Carry
);

    // internal adder/subtractor with explicit carry-out
    logic [32:0] sum;       // 33 bits, and the bit 32 = carry out
    logic        subtract;

    assign subtract = (AlUControl == 4'b0110) || (AlUControl == 4'b0111) || (AlUControl == 4'b0011);
    // SUB, SLT, and SLTU all route through the subtractor (SrcA - SrcB)

    assign sum = subtract ? ({1'b0, SrcA} + {1'b0, ~SrcB} + 33'b1) : ({1'b0, SrcA} + {1'b0, SrcB});

    always_comb begin
        // default values
        ALUResult = 32'b0;
        Negative  = 1'b0;
        Overflow  = 1'b0;
        Carry     = 1'b0;

        case(AlUControl)
            // ADD
            4'b0010: begin
                ALUResult = sum[31:0];
                Carry     = sum[32];
                Negative  = ALUResult[31];
                Overflow  = (SrcA[31] == SrcB[31]) && (ALUResult[31] != SrcA[31]);
            end
            // SUB
            4'b0110: begin
                ALUResult = sum[31:0];
                Carry     = sum[32];
                Negative  = ALUResult[31];
                Overflow  = (SrcA[31] != SrcB[31]) && (ALUResult[31] != SrcA[31]);
            end
            // AND
            4'b0000: begin
                ALUResult = SrcA & SrcB;
            end
            // OR
            4'b0001: begin
                ALUResult = SrcA | SrcB;
            end
            // SLT signed — derived from Negative XOR Overflow of the subtraction
            4'b0111: begin
                Carry     = sum[32];
                Negative  = sum[31];
                Overflow  = (SrcA[31] != SrcB[31]) && (sum[31] != SrcA[31]);
                ALUResult = (Negative ^ Overflow) ? 32'd1 : 32'd0;
            end
            // SLTU unsigned — derived from Carry of the subtraction (no borrow = Carry=1)
            4'b0011: begin
                Carry     = sum[32];
                ALUResult = Carry ? 32'd0 : 32'd1;
            end
            // SLL
            4'b1000: begin
                ALUResult = SrcA << SrcB[4:0];
            end
            // XOR
            4'b1001: begin
                ALUResult = SrcA ^ SrcB;
            end
            // SRL
            4'b1010: begin
                ALUResult = SrcA >> SrcB[4:0];
            end
            // SRA
            4'b1011: begin
                ALUResult = $signed(SrcA) >>> SrcB[4:0];
            end

            default: begin
                ALUResult = 32'b0;
            end

        endcase

    end

    assign Zero = (ALUResult == 32'b0);

endmodule : alu

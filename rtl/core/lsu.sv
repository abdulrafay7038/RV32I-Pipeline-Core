module lsu (
    input  logic [2:0]  func3,
    input  logic [31:0] ALUResult,
    input  logic [31:0] WD,
    input  logic [31:0] MRD,

    output logic [31:0] MWD,
    output logic [3:0]  WBE,
    output logic [31:0] RD
);

always_comb begin

    WBE = 4'b0000;
    MWD        = 32'b0;
    RD         = 32'b0;

    // LOAD
    case (func3)

        3'b000: begin // LB
            case (ALUResult[1:0])
                2'b00: RD = {{24{MRD[7]}},  MRD[7:0]};
                2'b01: RD = {{24{MRD[15]}}, MRD[15:8]};
                2'b10: RD = {{24{MRD[23]}}, MRD[23:16]};
                2'b11: RD = {{24{MRD[31]}}, MRD[31:24]};
            endcase
        end

        3'b001: begin // LH
            if (ALUResult[1] == 1'b0)
                RD = {{16{MRD[15]}}, MRD[15:0]};
            else
                RD = {{16{MRD[31]}}, MRD[31:16]};
        end

        3'b010: begin // LW
            RD = MRD;
        end

        3'b100: begin // LBU
            case (ALUResult[1:0])
                2'b00: RD = {24'b0, MRD[7:0]};
                2'b01: RD = {24'b0, MRD[15:8]};
                2'b10: RD = {24'b0, MRD[23:16]};
                2'b11: RD = {24'b0, MRD[31:24]};
            endcase
        end

        3'b101: begin // LHU
            if (ALUResult[1] == 1'b0)
                RD = {16'b0, MRD[15:0]};
            else
                RD = {16'b0, MRD[31:16]};
        end

        default:
            RD = 32'b0;

    endcase


    // STORE
    case (func3)

        3'b000: begin // SB
            MWD = {4{WD[7:0]}};

            case (ALUResult[1:0])
                2'b00: WBE = 4'b0001;
                2'b01: WBE = 4'b0010;
                2'b10: WBE = 4'b0100;
                2'b11: WBE = 4'b1000;
            endcase
        end

        3'b001: begin // SH
            MWD = {2{WD[15:0]}};
            if (ALUResult[1] == 1'b0)
                WBE = 4'b0011;
            else
                WBE = 4'b1100;
        end

        3'b010: begin // SW
            MWD = WD;
            WBE = 4'b1111;
        end

    endcase

    end
endmodule

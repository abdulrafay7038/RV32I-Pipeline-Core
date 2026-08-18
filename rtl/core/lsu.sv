module LSU(
    input logic [2:0]  func3,
    input logic [31:0] WD,
    input logic [31:0] MRD,

    output logic [31:0] MWD,
    output logic [31:0] RD
);

    always_comb begin : LOAD
        case(func3) 
            3'b000: RD = {{24{MRD[7]}},MRD[7:0]};        //Byte
            3'b001: RD = {{16{MRD[15]}},MRD[15:0]};      //Half
            3'b010: RD = MRD;                          //Word
            3'b100: RD = {{24{1'b0}},MRD[7:0]};             //Byte-Unsigned
            3'b101: RD = {{16{1'b0}},MRD[15:0]};            //Half-Unsigned
            default: RD = MRD;
        endcase
    end

    always_comb begin : STORE
        case(func3)
            3'b000: MWD = {{24{1'b0}}, WD[7:0]};      //Byte
            3'b001: MWD = {{16{1'b0}}, WD[15:0]};     //Half
            3'b010: MWD = WD;                      //Word
            default: MWD = WD;
        endcase
    end

endmodule
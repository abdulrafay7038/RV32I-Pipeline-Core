module regfile (
    input  logic        CLK,
    input  logic        RST,
    input  logic [4:0]  A1, A2, A3,
    input  logic [31:0] WD3,
    input  logic        WE3,
    
    output logic [31:0] RD1, RD2
);

    logic [31:0] x [31:0];          // 32 general purpose registers

    always_ff @(negedge CLK) begin
    if (RST)
        for (int i=0;i<32;i++) begin
            x[i] <= 0;
        end
    else if (WE3 && A3 != 5'b00000)
        x[A3] <= WD3;
    end

    assign RD1 = x[A1];
    assign RD2 = x[A2];

endmodule : regfile

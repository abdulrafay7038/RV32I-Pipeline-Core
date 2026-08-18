module pc (
    input  logic         CLK,
    input  logic         RST,
    input  logic  [31:0] PCNext,   // next PC value

    output logic  [31:0] PC        // current PC
);

    // update PC on each clock edge
    always_ff @(posedge CLK) begin
        if (RST)
            PC <= 32'd0;           // reset PC
        else 
            PC <= PCNext;          // load next PC
    end

endmodule : pc

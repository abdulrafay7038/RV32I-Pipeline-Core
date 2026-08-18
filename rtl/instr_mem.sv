module instr_mem #(
    parameter MEM_DEPTH = 2048
)(
    input  logic [31:0] A,
    output logic [31:0] RD
);

    // instruction memory
    logic [31:0] mem [0:MEM_DEPTH-1];

    // word-aligned instruction fetch
    assign RD = mem[A[31:2]];

endmodule: instr_mem

module data_mem #(
    parameter MEM_DEPTH = 6144
)(
    input  logic         CLK,
    input  logic         WE,    // Write enable
    input  logic  [31:0] A,     // Byte address
    input  logic  [31:0] WD,    // Write data
    output logic  [31:0] RD     // Read data
);

    // 32-bit word memory

    logic [31:0] data_mem [0:MEM_DEPTH-1];

    // synchronous write
    always_ff @(posedge CLK) begin
        if (WE)
            data_mem[A[$clog2(MEM_DEPTH)+1:2]] <= WD;
    end

    // asynchronous read
    assign RD = data_mem[A[$clog2(MEM_DEPTH)+1:2]];

endmodule : data_mem

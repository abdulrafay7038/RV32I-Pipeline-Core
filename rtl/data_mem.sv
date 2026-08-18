module data_mem (
    input  logic        CLK,
    input  logic        WE,
    input  logic [31:0] A,
    input  logic [31:0] WD,
    input  logic [3:0]  WBE,
    output logic [31:0] RD
);

    logic [7:0] data_mem [0:4095];

    // READ 
    always_comb begin
        RD = {data_mem[A + 32'd3],data_mem[A + 32'd2],data_mem[A + 32'd1],data_mem[A]};
    end

    // WRITE 
    always_ff @(posedge CLK) begin

        if (WE) begin

            if (WBE[0])
                data_mem[A][7:0] <= WD[7:0];

            if (WBE[1])
                data_mem[A + 32'd1] <= WD[15:8];

            if (WBE[2])
                data_mem[A + 32'd2] <= WD[23:16];

            if (WBE[3])
                data_mem[A + 32'd3] <= WD[31:24];

        end

    end

endmodule
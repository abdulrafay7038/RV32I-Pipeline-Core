`timescale 1ns/1ps
module mergesort_tb;

    logic clk;
    logic rst;

    top DUT (
        .CLK(clk),
        .RST(rst)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, mergesort_tb);
        clk = 1;
        rst = 1;
        $readmemh("mergesort.hex", DUT.Datapath.InstrMem.mem);
        $readmemh("datamem.hex", DUT.Datapath.DataMem.data_mem);
        // Hold reset for one clock cycles
        @(posedge clk);
        rst = 0;
        @(negedge clk) DUT.Datapath.Regfile.x[2] = 6143; // Initialize Stack Pointer


    end
endmodule        
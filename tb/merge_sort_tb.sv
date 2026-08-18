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
        $dumpfile("mergesort.vcd");
        $dumpvars(0, mergesort_tb);
        clk = 1;
        rst = 1;
        $readmemh("../program/machinecode/mergesort.hex", DUT.Datapath.InstrMem.mem);
        $readmemh("../program/machinecode/datamem.hex", DUT.Datapath.DataMem.data_mem);
        // Hold reset for one clock cycles
        @(posedge clk);
        rst = 0;
        @(negedge clk) DUT.Datapath.Regfile.x[2] = 6140; // Initialize Stack Pointer


    end
endmodule        
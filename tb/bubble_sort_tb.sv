module bubblesort_tb;

    logic clk;
    logic rst;

    top DUT (
        .CLK(clk),
        .RST(rst)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("bubblesort.vcd");
        $dumpvars(0, bubblesort_tb);
        clk = 1;
        rst = 1;
        $readmemh("../program/machinecode/bubblesort.hex", DUT.Datapath.InstrMem.mem);
        $readmemh("../program/machinecode/datamem.hex", DUT.Datapath.DataMem.data_mem);
        // Hold reset for one clock cycles
        @(posedge clk);
        rst = 0;
        @(negedge clk) DUT.Datapath.Regfile.x[2] = 6140; // Initialize Stack Pointer


    end
endmodule        
module factorial_tb;

    logic clk;
    logic rst;

    top DUT (
        .CLK(clk),
        .RST(rst)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("factorial.vcd");
        $dumpvars(0, factorial_tb);
        clk = 1;
        rst = 1;
        $readmemh("../program/machinecode/factorial.hex", DUT.Datapath.InstrMem.mem);
        // Hold reset for one clock cycles
        @(posedge clk);
        rst = 0;
        @(negedge clk) DUT.Datapath.Regfile.x[2] = 4092; // Initialize Stack Pointer

        #3000;
        if (DUT.Datapath.Regfile.x[10] == 120) begin
            $display("PASS: Expected 120, Actual %0d",DUT.Datapath.Regfile.x[10]);
        end
        else
            $fatal("FAIL: Expected 120, Actual %0d",DUT.Datapath.Regfile.x[10]);

    end
endmodule        
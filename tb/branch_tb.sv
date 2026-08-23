module branch_tb;
    logic clk;
    logic rst;

    top DUT (
        .CLK(clk),
        .RST(rst)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("branch_tb.vcd");
        $dumpvars(0, branch_tb);
        clk = 1;
        rst = 1;
        $readmemh("../program/machinecode/branch_predictor.hex", DUT.Datapath.InstrMem.mem);
        // Hold reset for two clock cycles
        #10;
        rst = 0;
        #900; 
        if (DUT.Datapath.Regfile.x[1] == 32'd10)
            $display("PASS: TEST 1 - x1 = %0d", DUT.Datapath.Regfile.x[1]);
        else
            $fatal(1, "FAIL: TEST 1 - x1 expected 10, got %0d",
                   DUT.Datapath.Regfile.x[1]);


        if (DUT.Datapath.Regfile.x[2] == 32'd10)
            $display("PASS: TEST 1 - x2 = %0d", DUT.Datapath.Regfile.x[2]);
        else
            $fatal(1, "FAIL: TEST 1 - x2 expected 10, got %0d",
                   DUT.Datapath.Regfile.x[2]);


        // TEST 2


        if (DUT.Datapath.Regfile.x[4] == 32'd10)
            $display("PASS: TEST 2 - x4 = %0d", DUT.Datapath.Regfile.x[4]);
        else
            $fatal(1, "FAIL: TEST 2 - x4 expected 10, got %0d",
                   DUT.Datapath.Regfile.x[4]);


        if (DUT.Datapath.Regfile.x[5] == 32'd20)
            $display("PASS: TEST 2 - x5 = %0d", DUT.Datapath.Regfile.x[5]);
        else
            $fatal(1, "FAIL: TEST 2 - x5 expected 20, got %0d",
                   DUT.Datapath.Regfile.x[5]);


        if (DUT.Datapath.Regfile.x[6] == 32'd2)
            $display("PASS: TEST 2 - x6 = %0d", DUT.Datapath.Regfile.x[6]);
        else
            $fatal(1, "FAIL: TEST 2 - x6 expected 2, got %0d",
                   DUT.Datapath.Regfile.x[6]);

        // TEST 3

        if (DUT.Datapath.Regfile.x[7] == 32'd20)
            $display("PASS: TEST 3 - x7 = %0d", DUT.Datapath.Regfile.x[7]);
        else
            $fatal(1, "FAIL: TEST 3 - x7 expected 20, got %0d",
                   DUT.Datapath.Regfile.x[7]);


        if (DUT.Datapath.Regfile.x[8] == 32'd20)
            $display("PASS: TEST 3 - x8 = %0d", DUT.Datapath.Regfile.x[8]);
        else
            $fatal(1, "FAIL: TEST 3 - x8 expected 20, got %0d",
                   DUT.Datapath.Regfile.x[8]);


        if (DUT.Datapath.Regfile.x[3] == 32'd123)
            $display("PASS: TEST 3 - x3 = %0d", DUT.Datapath.Regfile.x[3]);
        else
            $fatal(1, "FAIL: TEST 3 - x3 expected 123, got %0d",
                   DUT.Datapath.Regfile.x[3]);


        $display("----------------------------------");
        $display("ALL BRANCH TESTS PASSED!");
        $display("----------------------------------");

        $finish;

    end

endmodule
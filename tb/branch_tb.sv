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
        $readmemh("../program/machinecode/branch.hex", DUT.Datapath.InstrMem.mem);
        // Hold reset for two clock cycles
        #10;
        rst = 0;
        #860; 
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
        #100;
        // TEST 4 

        if (DUT.Datapath.Regfile.x[9] == 32'd5)
            $display("PASS: TEST 4 - x9 = %0d", DUT.Datapath.Regfile.x[9]);
        else
            $fatal(1, "FAIL: TEST 4 - x9 expected 5, got %0d",
                   DUT.Datapath.Regfile.x[9]);

        if (DUT.Datapath.Regfile.x[11] == 32'd1)
            $display("PASS: TEST 4 - x11 = %0d", DUT.Datapath.Regfile.x[11]);
        else
            $fatal(1, "FAIL: TEST 4 - x11 expected 1, got %0d",
                   DUT.Datapath.Regfile.x[11]);
        #100;
        // TEST 5 

        if (DUT.Datapath.Regfile.x[12] == 32'd7)
            $display("PASS: TEST 5 - x12 = %0d", DUT.Datapath.Regfile.x[12]);
        else
            $fatal(1, "FAIL: TEST 5 - x12 expected 7, got %0d",
                   DUT.Datapath.Regfile.x[12]);

        if (DUT.Datapath.Regfile.x[14] == 32'd1)
            $display("PASS: TEST 5 - x14 = %0d", DUT.Datapath.Regfile.x[14]);
        else
            $fatal(1, "FAIL: TEST 5 - x14 expected 1, got %0d",
                   DUT.Datapath.Regfile.x[14]);
        #100;
        // TEST 6 

        if (DUT.Datapath.Regfile.x[15] == 32'd25)
            $display("PASS: TEST 6 - x15 = %0d", DUT.Datapath.Regfile.x[15]);
        else
            $fatal(1, "FAIL: TEST 6 - x15 expected 25, got %0d",
                   DUT.Datapath.Regfile.x[15]);

        if (DUT.Datapath.Regfile.x[17] == 32'd25)
            $display("PASS: TEST 6 - x17 = %0d", DUT.Datapath.Regfile.x[17]);
        else
            $fatal(1, "FAIL: TEST 6 - x17 expected 25, got %0d",
                   DUT.Datapath.Regfile.x[17]);

        if (DUT.Datapath.Regfile.x[19] == 32'd1)
            $display("PASS: TEST 6 - x19 = %0d", DUT.Datapath.Regfile.x[19]);
        else
            $fatal(1, "FAIL: TEST 6 - x19 expected 1, got %0d",
                   DUT.Datapath.Regfile.x[19]);

        #100;
        // TEST 7 

        if (DUT.Datapath.Regfile.x[22] == 32'd1)
            $display("PASS: TEST 7 - x22 = %0d", DUT.Datapath.Regfile.x[22]);
        else
            $fatal(1, "FAIL: TEST 7 - x22 expected 1, got %0d",
                   DUT.Datapath.Regfile.x[22]);
        #100;
        // TEST 8 

        if (DUT.Datapath.Regfile.x[25] == 32'd10)
            $display("PASS: TEST 8 - x25 = %0d", DUT.Datapath.Regfile.x[25]);
        else
            $fatal(1, "FAIL: TEST 8 - x25 expected 10, got %0d",
                   DUT.Datapath.Regfile.x[25]);

        if (DUT.Datapath.Regfile.x[26] == 32'd1)
            $display("PASS: TEST 8 - x26 = %0d", DUT.Datapath.Regfile.x[26]);
        else
            $fatal(1, "FAIL: TEST 8 - x26 expected 1, got %0d",
                   DUT.Datapath.Regfile.x[26]);
        #100;
        // TEST 9 

        if (DUT.Datapath.Regfile.x[30] == 32'd77)
            $display("PASS: TEST 9 - x30 = %0d", DUT.Datapath.Regfile.x[30]);
        else
            $fatal(1, "FAIL: TEST 9 - x30 expected 77, got %0d",
                   DUT.Datapath.Regfile.x[30]);

        if (DUT.Datapath.Regfile.x[29] == 32'd1)
            $display("PASS: TEST 9 - x29 = %0d", DUT.Datapath.Regfile.x[29]);
        else
            $fatal(1, "FAIL: TEST 9 - x29 expected 1, got %0d",
                   DUT.Datapath.Regfile.x[29]);
        #100;
        // TEST 10 

        if (DUT.Datapath.Regfile.x[3] == 32'd10)
            $display("PASS: TEST 10 - x3 = %0d", DUT.Datapath.Regfile.x[3]);
        else
            $fatal(1, "FAIL: TEST 10 - x3 expected 10, got %0d",
                   DUT.Datapath.Regfile.x[3]);
        #100;
        // TEST 11 

        if (DUT.Datapath.Regfile.x[4] == 32'd1)
            $display("PASS: TEST 11 - x4 = %0d", DUT.Datapath.Regfile.x[4]);
        else
            $fatal(1, "FAIL: TEST 11 - x4 expected 1, got %0d",
                   DUT.Datapath.Regfile.x[4]);

        if (DUT.Datapath.Regfile.x[5] == 32'd3)
            $display("PASS: TEST 11 - x5 = %0d", DUT.Datapath.Regfile.x[5]);
        else
            $fatal(1, "FAIL: TEST 11 - x5 expected 3, got %0d",
                   DUT.Datapath.Regfile.x[5]);
        #300;
        // TEST 12 

        if (DUT.Datapath.Regfile.x[6] == 32'd5)
            $display("PASS: TEST 12 - x6 = %0d", DUT.Datapath.Regfile.x[6]);
        else
            $fatal(1, "FAIL: TEST 12 - x6 expected 5, got %0d",
                   DUT.Datapath.Regfile.x[6]);
        #550;
        // TEST 13 

        if (DUT.Datapath.Regfile.x[10] == 32'd1)
            $display("PASS: TEST 13 - x10 = %0d", DUT.Datapath.Regfile.x[10]);
        else
            $fatal(1, "FAIL: TEST 13 - x10 expected 1, got %0d",
                   DUT.Datapath.Regfile.x[10]);

        if (DUT.Datapath.Regfile.x[11] == 32'd10)
            $display("PASS: TEST 13 - x11 = %0d", DUT.Datapath.Regfile.x[11]);
        else
            $fatal(1, "FAIL: TEST 13 - x11 expected 10, got %0d",
                   DUT.Datapath.Regfile.x[11]);
        #300;
        // TEST 14 

        if (DUT.Datapath.Regfile.x[13] == 32'd1)
            $display("PASS: TEST 14 - x13 = %0d", DUT.Datapath.Regfile.x[13]);
        else
            $fatal(1, "FAIL: TEST 14 - x13 expected 1, got %0d",
                   DUT.Datapath.Regfile.x[13]);

        if (DUT.Datapath.Regfile.x[14] == 32'd10)
            $display("PASS: TEST 14 - x14 = %0d", DUT.Datapath.Regfile.x[14]);
        else
            $fatal(1, "FAIL: TEST 14 - x14 expected 10, got %0d",
                   DUT.Datapath.Regfile.x[14]);
        #100;
        // TEST 15 

        if (DUT.Datapath.Regfile.x[16] == 32'd0)
            $display("PASS: TEST 15 - x16 = %0d", DUT.Datapath.Regfile.x[16]);
        else
            $fatal(1, "FAIL: TEST 15 - x16 expected 1, got %0d",
                   DUT.Datapath.Regfile.x[16]);

        if (DUT.Datapath.Regfile.x[18] == 32'd2)
            $display("PASS: TEST 15 - x18 = %0d", DUT.Datapath.Regfile.x[18]);
        else
            $fatal(1, "FAIL: TEST 15 - x18 expected 2, got %0d",
                   DUT.Datapath.Regfile.x[18]);
        #80;
        // TEST 16 

        if (DUT.Datapath.Regfile.x[19] == 32'd1)
            $display("PASS: TEST 16 - x19 = %0d", DUT.Datapath.Regfile.x[19]);
        else
            $fatal(1, "FAIL: TEST 16 - x19 expected 1, got %0d",
                   DUT.Datapath.Regfile.x[19]);

        if (DUT.Datapath.Regfile.x[20] == 32'd1)
            $display("PASS: TEST 16 - x20 = %0d", DUT.Datapath.Regfile.x[20]);
        else
            $fatal(1, "FAIL: TEST 16 - x20 expected 1, got %0d",
                   DUT.Datapath.Regfile.x[20]);
        #80;
        // TEST 17 

        if (DUT.Datapath.Regfile.x[24] == 32'd1)
            $display("PASS: TEST 17 - x24 = %0d", DUT.Datapath.Regfile.x[24]);
        else
            $fatal(1, "FAIL: TEST 17 - x24 expected 1, got %0d",
                   DUT.Datapath.Regfile.x[24]);
        #80;
        // TEST 18

        if (DUT.Datapath.Regfile.x[27] == 32'd1)
            $display("PASS: TEST 18 - x27 = %0d", DUT.Datapath.Regfile.x[27]);
        else
            $fatal(1, "FAIL: TEST 18 - x27 expected 1, got %0d",
                   DUT.Datapath.Regfile.x[27]);

        if (DUT.Datapath.Regfile.x[30] == 32'd30)
            $display("PASS: TEST 18 - x30 = %0d", DUT.Datapath.Regfile.x[30]);
        else
            $fatal(1, "FAIL: TEST 18 - x30 expected 30, got %0d",
                   DUT.Datapath.Regfile.x[30]);
        #80;
        // TEST 19 

        if (DUT.Datapath.Regfile.x[28] == 32'd1)
            $display("PASS: TEST 19 - x28 = %0d", DUT.Datapath.Regfile.x[28]);
        else
            $fatal(1, "FAIL: TEST 19 - x28 expected 1, got %0d",
                   DUT.Datapath.Regfile.x[28]);
        #80;
        // TEST 20 

        if (DUT.Datapath.Regfile.x[30] == 32'd1234)
            $display("PASS: TEST 20 - x30 = %0d", DUT.Datapath.Regfile.x[30]);
        else
            $fatal(1, "FAIL: TEST 20 - x30 expected 1234, got %0d",
                   DUT.Datapath.Regfile.x[30]);

        $display("========================================");
        $display("ALL BRANCH TESTS PASSED");
        $display("========================================");


        $finish;

    end

endmodule
module arithmetic_tb;

    logic clk;
    logic rst;

    top DUT (
        .CLK(clk),
        .RST(rst)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("arithmetic.vcd");
        $dumpvars(0, arithmetic_tb);
        clk = 1;
        rst = 1;
        $readmemh("../program/machinecode/arithmetic.hex", DUT.Datapath.InstrMem.mem);
        // Hold reset for two clock cycles
        #20;
        rst = 0;

        // 40 instructions, 3 stage -> well past enough cycles
        #485;

        // Setup registers
        if (DUT.Datapath.Regfile.x[1] !== 32'd5)
            $fatal(1, "FAIL: x1 expected 5, got %0d", DUT.Datapath.Regfile.x[1]);

        if (DUT.Datapath.Regfile.x[2] !== 32'd5)
            $fatal(1, "FAIL: x2 expected 5, got %0d", DUT.Datapath.Regfile.x[2]);

        if (DUT.Datapath.Regfile.x[3] !== 32'd10)
            $fatal(1, "FAIL: x3 expected 10, got %0d", DUT.Datapath.Regfile.x[3]);

        if (DUT.Datapath.Regfile.x[4] !== 32'h7FF)
            $fatal(1, "FAIL: x4 expected 0x7FF, got %0h", DUT.Datapath.Regfile.x[4]);

        // BEQ taken (x1==x2): x5 should stay 0, x6 should be 2
        if (DUT.Datapath.Regfile.x[5] !== 32'd0)
            $fatal(1, "FAIL: x5 expected 0 (BEQ should have skipped), got %0d", DUT.Datapath.Regfile.x[5]);
        if (DUT.Datapath.Regfile.x[6] !== 32'd2)
            $fatal(1, "FAIL: x6 expected 2, got %0d", DUT.Datapath.Regfile.x[6]);

        // BEQ not taken (x1 vs x3): x7 and x8 should both execute
        if (DUT.Datapath.Regfile.x[7] !== 32'd3)
            $fatal(1, "FAIL: x7 expected 3 (BEQ should not have branched), got %0d", DUT.Datapath.Regfile.x[7]);
        if (DUT.Datapath.Regfile.x[8] !== 32'd4)
            $fatal(1, "FAIL: x8 expected 4, got %0d", DUT.Datapath.Regfile.x[8]);

        // BNE taken (x1 vs x3): x9 should stay 0, x10 should be 6
        if (DUT.Datapath.Regfile.x[9] !== 32'd0)
            $fatal(1, "FAIL: x9 expected 0 (BNE should have skipped), got %0d", DUT.Datapath.Regfile.x[9]);
        if (DUT.Datapath.Regfile.x[10] !== 32'd6)
            $fatal(1, "FAIL: x10 expected 6, got %0d", DUT.Datapath.Regfile.x[10]);

        // BNE not taken (x1==x2): x11 and x12 should both execute
        if (DUT.Datapath.Regfile.x[11] !== 32'd7)
            $fatal(1, "FAIL: x11 expected 7 (BNE should not have branched), got %0d", DUT.Datapath.Regfile.x[11]);
        if (DUT.Datapath.Regfile.x[12] !== 32'd8)
            $fatal(1, "FAIL: x12 expected 8, got %0d", DUT.Datapath.Regfile.x[12]);

        // BLT taken (5<10): x13 should stay 0, x14 should be 10
        if (DUT.Datapath.Regfile.x[13] !== 32'd0)
            $fatal(1, "FAIL: x13 expected 0 (BLT should have skipped), got %0d", DUT.Datapath.Regfile.x[13]);
        if (DUT.Datapath.Regfile.x[14] !== 32'd10)
            $fatal(1, "FAIL: x14 expected 10, got %0d", DUT.Datapath.Regfile.x[14]);

        // BLT not taken (10<5 false): x15 and x16 should both execute
        if (DUT.Datapath.Regfile.x[15] !== 32'd11)
            $fatal(1, "FAIL: x15 expected 11 (BLT should not have branched), got %0d", DUT.Datapath.Regfile.x[15]);
        if (DUT.Datapath.Regfile.x[16] !== 32'd12)
            $fatal(1, "FAIL: x16 expected 12, got %0d", DUT.Datapath.Regfile.x[16]);

        // BGE taken (10>=5): x17 should stay 0, x18 should be 14
        if (DUT.Datapath.Regfile.x[17] !== 32'd0)
            $fatal(1, "FAIL: x17 expected 0 (BGE should have skipped), got %0d", DUT.Datapath.Regfile.x[17]);
        if (DUT.Datapath.Regfile.x[18] !== 32'd14)
            $fatal(1, "FAIL: x18 expected 14, got %0d", DUT.Datapath.Regfile.x[18]);

        // BGE not taken (5>=10 false): x19 and x20 should both execute
        if (DUT.Datapath.Regfile.x[19] !== 32'd15)
            $fatal(1, "FAIL: x19 expected 15 (BGE should not have branched), got %0d", DUT.Datapath.Regfile.x[19]);
        if (DUT.Datapath.Regfile.x[20] !== 32'd16)
            $fatal(1, "FAIL: x20 expected 16, got %0d", DUT.Datapath.Regfile.x[20]);

        // BLTU taken (5 <u 0xFFFFFFFF): x21 should stay 0, x22 should be 18
        if (DUT.Datapath.Regfile.x[21] !== 32'd0)
            $fatal(1, "FAIL: x21 expected 0 (BLTU should have skipped), got %0d", DUT.Datapath.Regfile.x[21]);
        if (DUT.Datapath.Regfile.x[22] !== 32'd18)
            $fatal(1, "FAIL: x22 expected 18, got %0d", DUT.Datapath.Regfile.x[22]);

        // BLTU not taken (0xFFFFFFFF <u 5 false): x23 and x24 should both execute
        if (DUT.Datapath.Regfile.x[23] !== 32'd19)
            $fatal(1, "FAIL: x23 expected 19 (BLTU should not have branched), got %0d", DUT.Datapath.Regfile.x[23]);
        if (DUT.Datapath.Regfile.x[24] !== 32'd20)
            $fatal(1, "FAIL: x24 expected 20, got %0d", DUT.Datapath.Regfile.x[24]);

        // BGEU taken (0xFFFFFFFF >=u 5): x25 should stay 0, x26 should be 22
        if (DUT.Datapath.Regfile.x[25] !== 32'd0)
            $fatal(1, "FAIL: x25 expected 0 (BGEU should have skipped), got %0d", DUT.Datapath.Regfile.x[25]);
        if (DUT.Datapath.Regfile.x[26] !== 32'd22)
            $fatal(1, "FAIL: x26 expected 22, got %0d", DUT.Datapath.Regfile.x[26]);

        // BGEU not taken (5 >=u 0xFFFFFFFF false): x27 and x28 should both execute
        if (DUT.Datapath.Regfile.x[27] !== 32'd23)
            $fatal(1, "FAIL: x27 expected 23 (BGEU should not have branched), got %0d", DUT.Datapath.Regfile.x[27]);
        if (DUT.Datapath.Regfile.x[28] !== 32'd24)
            $fatal(1, "FAIL: x28 expected 24, got %0d", DUT.Datapath.Regfile.x[28]);

        // LUI: x29 = 0x12345000
        if (DUT.Datapath.Regfile.x[29] !== 32'h12345000)
            $fatal(1, "FAIL: x29 expected 0x12345000 after LUI, got 0x%08h", DUT.Datapath.Regfile.x[29]);   

        // AUIPC: x30 = PC + 0x1000
        if (DUT.Datapath.Regfile.x[30] !== 32'h000010A4)
            $fatal(1, "FAIL: x30 expected 0x000010A0 after AUIPC, got 0x%08h", DUT.Datapath.Regfile.x[30]);     
        
        $display("ALL TESTS PASSED SUCCESSFULLY");
        $finish();
    end

endmodule

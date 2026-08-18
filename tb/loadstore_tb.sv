module loadstore_tb;

    logic clk;
    logic rst;

    top DUT (
        .CLK(clk),
        .RST(rst)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("loadstore.vcd");
        $dumpvars(0, loadstore_tb);
        clk = 1;
        rst = 1;
        $readmemh("../program/machinecode/loadstore.hex", DUT.Datapath.InstrMem.mem);
        // Hold reset for one clock cycles
        @(posedge clk);
        rst = 0;
        #600;

    if (DUT.Datapath.Regfile.x[1] != 32'h00000100)
        $fatal(1,"FAIL: x[1] expected 0x00000100 got %0h",DUT.Datapath.Regfile.x[1]);

    if (DUT.Datapath.Regfile.x[2] != 32'h12345678)
        $fatal(1,"FAIL: x[2] expected 0x12345678 got %0h",DUT.Datapath.Regfile.x[2]);

    if (DUT.Datapath.Regfile.x[3] != 32'hFFFFF800)
        $fatal(1,"FAIL: x[3] expected 0xFFFFF800 got %0h",DUT.Datapath.Regfile.x[3]);


    if (DUT.Datapath.Regfile.x[4] != 32'h00000078)
        $fatal(1,"FAIL: x[4] expected 0x00000078 got %0h",DUT.Datapath.Regfile.x[4]);

    if (DUT.Datapath.Regfile.x[5] != 32'h00000056)
        $fatal(1,"FAIL: x[5] expected 0x00000056 got %0h",DUT.Datapath.Regfile.x[5]);

    if (DUT.Datapath.Regfile.x[6] != 32'h00000034)
        $fatal(1,"FAIL: x[6] expected 0x00000034 got %0h",DUT.Datapath.Regfile.x[6]);

    if (DUT.Datapath.Regfile.x[7] != 32'h00000012)
        $fatal(1,"FAIL: x[7] expected 0x00000012 got %0h",DUT.Datapath.Regfile.x[7]);

    if (DUT.Datapath.Regfile.x[8] != 32'h00000078)
        $fatal(1,"FAIL: x[8] expected 0x00000078 got %0h",DUT.Datapath.Regfile.x[8]);

    if (DUT.Datapath.Regfile.x[9] != 32'h00000056)
        $fatal(1,"FAIL: x[9] expected 0x00000056 got %0h",DUT.Datapath.Regfile.x[9]);

    if (DUT.Datapath.Regfile.x[10] != 32'h00000034)
        $fatal(1,"FAIL: x[10] expected 0x00000034 got %0h",DUT.Datapath.Regfile.x[10]);

    if (DUT.Datapath.Regfile.x[11] != 32'h00000012)
        $fatal(1,"FAIL: x[11] expected 0x00000012 got %0h",DUT.Datapath.Regfile.x[11]);


    if (DUT.Datapath.Regfile.x[12] != 32'hABCD0123)
        $fatal(1,"FAIL: x[12] expected 0xABCD0123 got %0h",DUT.Datapath.Regfile.x[12]);

    if (DUT.Datapath.Regfile.x[13] != 32'h00000123)
        $fatal(1,"FAIL: x[13] expected 0x00000123 got %0h",DUT.Datapath.Regfile.x[13]);

    if (DUT.Datapath.Regfile.x[14] != 32'h00000123)
        $fatal(1,"FAIL: x[14] expected 0x00000123 got %0h",DUT.Datapath.Regfile.x[14]);

    if (DUT.Datapath.Regfile.x[15] != 32'h00000123)
        $fatal(1,"FAIL: x[15] expected 0x00000123 got %0h",DUT.Datapath.Regfile.x[15]);

    if (DUT.Datapath.Regfile.x[16] != 32'h00000123)
        $fatal(1,"FAIL: x[16] expected 0x00000123 got %0h",DUT.Datapath.Regfile.x[16]);


    if (DUT.Datapath.Regfile.x[17] != 32'h00000044)
        $fatal(1,"FAIL: x[17] expected 0x00000044 got %0h",DUT.Datapath.Regfile.x[17]);

    if (DUT.Datapath.Regfile.x[18] != 32'h44332211)
        $fatal(1,"FAIL: x[18] expected 0x44332211 got %0h",DUT.Datapath.Regfile.x[18]);



    if (DUT.Datapath.Regfile.x[19] != 32'hFFFFFFFF)
        $fatal(1,"FAIL: x[19] expected 0xFFFFFFFF got %0h",DUT.Datapath.Regfile.x[19]);

    if (DUT.Datapath.Regfile.x[20] != 32'hFFFFFFFF)
        $fatal(1,"FAIL: x[20] expected 0xFFFFFFFF got %0h",DUT.Datapath.Regfile.x[20]);

    if (DUT.Datapath.Regfile.x[21] != 32'h000000FF)
        $fatal(1,"FAIL: x[21] expected 0x000000FF got %0h",DUT.Datapath.Regfile.x[21]);



    if (DUT.Datapath.Regfile.x[22] != 32'h00008000)
        $fatal(1,"FAIL: x[22] expected 0x00008000 got %0h",DUT.Datapath.Regfile.x[22]);

    if (DUT.Datapath.Regfile.x[23] != 32'hFFFF8000)
        $fatal(1,"FAIL: x[23] expected 0xFFFF8000 got %0h",DUT.Datapath.Regfile.x[23]);

    if (DUT.Datapath.Regfile.x[24] != 32'h00008000)
        $fatal(1,"FAIL: x[24] expected 0x00008000 got %0h",DUT.Datapath.Regfile.x[24]);



    if (DUT.Datapath.Regfile.x[25] != 32'hDEADBEEF)
        $fatal(1,"FAIL: x[25] expected 0xDEADBEEF got %0h",DUT.Datapath.Regfile.x[25]);

    if (DUT.Datapath.Regfile.x[26] != 32'h000000AA)
        $fatal(1,"FAIL: x[26] expected 0x000000AA got %0h",DUT.Datapath.Regfile.x[26]);

    if (DUT.Datapath.Regfile.x[27] != 32'hDEADAAEF)
        $fatal(1,"FAIL: x[27] expected 0xDEADAAEF got %0h",DUT.Datapath.Regfile.x[27]);


    if (DUT.Datapath.Regfile.x[28] != 32'h00000123)
        $fatal(1,"FAIL: x[28] expected 0x00000123 got %0h",DUT.Datapath.Regfile.x[28]);

    if (DUT.Datapath.Regfile.x[29] != 32'h0123AAEF)
        $fatal(1,"FAIL: x[29] expected 0x0123AAEF got %0h",DUT.Datapath.Regfile.x[29]);


    $display("==========================================");
    $display("LOADSTORE TESTS PASSED");
    $display("==========================================");  
    $finish();                                             
    end
endmodule        
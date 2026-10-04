module Branch_Predictor_tb;
    // external signals
    logic        CLK;
    logic        RST;
    logic        Branch_taken;
    logic [31:0] InstE;
    logic [31:0] PCF;
    logic [31:0] PCE;
    logic [31:0] PCTargetE;
    logic [ 1:0] predictionE;
    logic [31:0] PCin;           //output
    logic [ 1:0] predictionF;    //output

    // internal signals
    logic        Branchop;
    logic        btb_hit;
    logic        bht_hit;
    logic        m1_sel;
    logic [ 1:0] UpdatedPrediction;
    logic [31:0] TargetAddress;

    BranchPredictor DUT (.*);

    assign Branchop          = DUT.Branchop;
    assign btb_hit           = DUT.btb_hit;
    assign bht_hit           = DUT.bht_hit;
    assign m1_sel            = DUT.m1_sel;
    assign UpdatedPrediction = DUT.UpdatedPrediction;
    assign TargetAddress     = DUT.TargetAddress;

task test(  logic [31:0] pc_in,    target_address,
            logic [ 1:0] predic_f, updated_prediction,                
            logic        b_branch, btb_h, bht_h, m1_s);

    if (PCin !== pc_in)
        $fatal(1, "PCin mismatch: expected %h, got %h", pc_in, PCin);

    // The BTB target is don't-care on a miss; the fetch path uses it only
    // when the BTB and BHT both hit and the direction predicts taken.
    if (btb_h && (TargetAddress !== target_address))
        $fatal(1, "TargetAddress mismatch: expected %h, got %h",
               target_address, TargetAddress);

    if (predictionF !== predic_f)
        $fatal(1, "predictionF mismatch: expected %b, got %b",
               predic_f, predictionF);

    if (UpdatedPrediction !== updated_prediction)
        $fatal(1, "UpdatedPrediction mismatch: expected %b, got %b",
               updated_prediction, UpdatedPrediction);

    if (Branchop !== b_branch)
        $fatal(1, "Branchop mismatch: expected %b, got %b", b_branch, Branchop);

    if (btb_hit !== btb_h)
        $fatal(1, "BTB hit mismatch: expected %b, got %b", btb_h, btb_hit);

    if (bht_hit !== bht_h)
        $fatal(1, "BHT hit mismatch: expected %b, got %b", bht_h, bht_hit);

    if (m1_sel !== m1_s)
        $fatal(1, "m1_sel mismatch: expected %b, got %b", m1_s, m1_sel);

endtask

always #5 CLK = ~CLK;

initial begin

        CLK = 1;
        RST = 1;

        Branch_taken = 1'b0;
        InstE        = 32'h00000000;
        PCF          = 32'h00000000;
        PCE          = 32'h00000000;
        PCTargetE    = 32'h00000000;
        predictionE  = 2'b01;

        #1;
    
        $display("-------RESET test starts!-------");  
        test(
            32'h00000004,    // PCin
            32'h00000000,    // TargetAddress
            2'b01,           // predictionF
            2'b01,           // UpdatedPrediction
            1'b0,            // Branchop
            1'b0,            // BTB hit
            1'b0,            // BHT hit
            1'b0             // m1_sel
        );
        $display("-------RESET test completed!-------");

        @(posedge CLK);
        #1;

        RST = 1'b0;

        PCE          = 32'h00000000;
        PCF          = 32'h00000004;
        InstE        = 32'h00508093;
        PCTargetE    = 32'h00000000;
        Branch_taken = 1'b0;
        predictionE  = 2'b01;

        @(posedge CLK);
        #1;

        $display("-------CYCLE 1 test starts!-------");
        test(
            32'h00000008,    // PCin
            32'h00000000,    // TargetAddress
            2'b01,           // predictionF
            2'b01,           // UpdatedPrediction
            1'b0,            // Branchop
            1'b0,            // BTB hit
            1'b0,            // BHT hit
            1'b0             // m1_sel
        );
        $display("-------CYCLE 1 test completed!-------");

        PCE          = 32'h00000004;
        PCF          = 32'h00000008;
        InstE        = 32'h00208863;
        PCTargetE    = 32'h00000014;
        Branch_taken = 1'b0;
        predictionE  = 2'b01;

        @(posedge CLK);
        #1;

        $display("-------CYCLE 2 test starts!-------");
        test(
            32'h0000000C,
            32'h00000000,
            2'b01,
            2'b00,
            1'b1,
            1'b0,
            1'b0,
            1'b0
        );
        $display("-------CYCLE 2 test completed!-------");

        PCE          = 32'h00000008;
        PCF          = 32'h0000000C;
        InstE        = 32'h002181B3;
        PCTargetE    = 32'h00000000;
        Branch_taken = 1'b0;
        predictionE  = 2'b01;

        @(posedge CLK);
        #1;

        $display("-------CYCLE 3 test starts!-------");
        test(
            32'h00000010,
            32'h00000000,
            2'b01,
            2'b01,
            1'b0,
            1'b0,
            1'b0,
            1'b0
        );
        $display("-------CYCLE 3 test completed!-------");

        PCE          = 32'h0000000C;
        PCF          = 32'h00000010;
        InstE        = 32'h00518193;
        PCTargetE    = 32'h00000000;
        Branch_taken = 1'b0;
        predictionE  = 2'b01;

        @(posedge CLK);
        #1;

        $display("-------CYCLE 4 test starts!-------");
        test(
            32'h00000014,
            32'h00000000,
            2'b01,
            2'b01,
            1'b0,
            1'b0,
            1'b0,
            1'b0
        );
        $display("-------CYCLE 4 test completed!-------");

        PCE          = 32'h00000010;
        PCF          = 32'h00000014;
        InstE        = 32'h0051D863;
        PCTargetE    = 32'h00000020;
        Branch_taken = 1'b0;
        predictionE  = 2'b01;

        @(posedge CLK);
        #1;

        $display("-------CYCLE 5 test starts!-------");
        test(
            32'h00000018,
            32'h00000000,
            2'b01,
            2'b00,
            1'b1,
            1'b0,
            1'b0,
            1'b0
        );
        $display("-------CYCLE 5 test completed!-------");

        PCE          = 32'h00000014;
        PCF          = 32'h00000018;
        InstE        = 32'h40118233;
        PCTargetE    = 32'h00000000;
        Branch_taken = 1'b0;
        predictionE  = 2'b01;

        @(posedge CLK);
        #1;

        $display("-------CYCLE 6 test starts!-------");
        test(
            32'h0000001C,
            32'h00000000,
            2'b01,
            2'b01,
            1'b0,
            1'b0,
            1'b0,
            1'b0
        );
        $display("-------CYCLE 6 test completed!-------");

        PCE          = 32'h00000018;
        PCF          = 32'h0000001C;
        InstE        = 32'h004101B3;
        PCTargetE    = 32'h00000000;
        Branch_taken = 1'b0;
        predictionE  = 2'b01;

        @(posedge CLK);
        #1;

        $display("-------CYCLE 7 test starts!-------");
        test(
            32'h00000020,
            32'h00000000,
            2'b01,
            2'b01,
            1'b0,
            1'b0,
            1'b0,
            1'b0
        );
        $display("-------CYCLE 7 test completed!-------");

        PCE          = 32'h0000001C;
        PCF          = 32'h00000004;
        InstE        = 32'hFE51C4E3;
        PCTargetE    = 32'h00000004;
        Branch_taken = 1'b1;
        predictionE  = 2'b01;

        @(posedge CLK);
        #1;

        $display("-------CYCLE 8 test starts!-------");
        test(
            32'h00000008,
            32'h00000014,
            2'b00,
            2'b10,
            1'b1,
            1'b1,
            1'b1,
            1'b0
        );
        $display("-------CYCLE 8 test completed!-------");

        PCE          = 32'h00000004;
        PCF          = 32'h00000008;
        InstE        = 32'h00208863;
        PCTargetE    = 32'h00000014;
        Branch_taken = 1'b0;
        predictionE  = 2'b00;

        @(posedge CLK);
        #1;

        $display("-------CYCLE 9 test starts!-------");
        test(
            32'h0000000C,
            32'h00000000,
            2'b01,
            2'b00,
            1'b1,
            1'b0,
            1'b0,
            1'b0
        );
        $display("-------CYCLE 9 test completed!-------");

        PCE          = 32'h00000008;
        PCF          = 32'h0000000C;
        InstE        = 32'h002181B3;
        PCTargetE    = 32'h00000000;
        Branch_taken = 1'b0;
        predictionE  = 2'b01;

        @(posedge CLK);
        #1;

        $display("-------CYCLE 10 test starts!-------");
        test(
            32'h00000010,
            32'h00000000,
            2'b01,
            2'b01,
            1'b0,
            1'b0,
            1'b0,
            1'b0
        );
        $display("-------CYCLE 10 test completed!-------");

        PCE          = 32'h0000000C;
        PCF          = 32'h00000010;
        InstE        = 32'h00518193;
        PCTargetE    = 32'h00000000;
        Branch_taken = 1'b0;
        predictionE  = 2'b01;

        @(posedge CLK);
        #1;

        $display("-------CYCLE 11 test starts!-------");
        test(
            32'h00000014,
            32'h00000020,
            2'b00,
            2'b01,
            1'b0,
            1'b1,
            1'b1,
            1'b0
        );
        $display("-------CYCLE 11 test completed!-------");

        PCE          = 32'h00000010;
        PCF          = 32'h00000014;
        InstE        = 32'h0051D863;
        PCTargetE    = 32'h00000020;
        Branch_taken = 1'b0;
        predictionE  = 2'b00;

        @(posedge CLK);
        #1;

        $display("-------CYCLE 12 test starts!-------");
        test(
            32'h00000018,
            32'h00000000,
            2'b01,
            2'b00,
            1'b1,
            1'b0,
            1'b0,
            1'b0
        );
        $display("-------CYCLE 12 test completed!-------");

        PCE          = 32'h00000014;
        PCF          = 32'h00000018;
        InstE        = 32'h40118233;
        PCTargetE    = 32'h00000000;
        Branch_taken = 1'b0;
        predictionE  = 2'b01;

        @(posedge CLK);
        #1;

        $display("-------CYCLE 13 test starts!-------");
        test(
            32'h0000001C,
            32'h00000000,
            2'b01,
            2'b01,
            1'b0,
            1'b0,
            1'b0,
            1'b0
        );
        $display("-------CYCLE 13 test completed!-------");

        PCE          = 32'h00000018;
        PCF          = 32'h0000001C;
        InstE        = 32'h004101B3;
        PCTargetE    = 32'h00000000;
        Branch_taken = 1'b0;
        predictionE  = 2'b01;

        @(posedge CLK);
        #1;

        $display("-------CYCLE 14 test starts!-------");
        test(
            32'h00000004,
            32'h00000004,
            2'b10,
            2'b01,
            1'b0,
            1'b1,
            1'b1,
            1'b1
        );
        $display("-------CYCLE 14 test completed!-------");

        PCE          = 32'h0000001C;
        PCF          = 32'h00000004;
        InstE        = 32'hFE51C4E3;
        PCTargetE    = 32'h00000004;
        Branch_taken = 1'b1;
        predictionE  = 2'b10;

        @(posedge CLK);
        #1;

        $display("-------CYCLE 15 test starts!-------");
        test(
            32'h00000008,
            32'h00000014,
            2'b00,
            2'b11,
            1'b1,
            1'b1,
            1'b1,
            1'b0
        );
        $display("-------CYCLE 15 test completed!-------");

        $display("-------All tests completed!-------");

        $finish;

end

endmodule

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
    
    assert(PCin == pc_in) else begin
        $display("Outgoing pc address is wrong");
        $display("Expected value = %h", pc_in);
        $display("Actual value   = %h", PCin);
        //$stop;
    end

    assert(TargetAddress == target_address) else begin
        $display("Predicted target address for fetched instruction is wrong.");
        $display("Expected value = %h", target_address);
        $display("Actual value   = %h", TargetAddress);
        //$stop;
    end

    assert(predictionF == predic_f) else begin
        $display("Prediction for fetched instruction is wrong.");
        $display("Expected value = %h", predic_f);
        $display("Actual value   = %h", predictionF);
        //$stop;
    end

    assert(UpdatedPrediction == updated_prediction) else begin
        $display("Updated prediction is wrong.");
        $display("Expected value = %h", updated_prediction);
        $display("Actual value   = %h", UpdatedPrediction);
        //$stop;
    end

    assert(Branchop == b_branch) else begin
        $display("Branch op is wrong.");
        $display("Expected value = %h", b_branch);
        $display("Actual value   = %h", Branchop);
        //$stop;
    end

    assert(btb_hit == btb_h) else begin
        $display("BTB's hit is wrong.");
        $display("Expected value = %h", btb_h);
        $display("Actual value   = %h", btb_hit);
        //$stop;
    end

    assert(bht_hit == bht_h) else begin
        $display("BHT's hit is wrong.");
        $display("Expected value = %h", bht_h);
        $display("Actual value   = %h", bht_hit);
        //$stop;
    end
    
    assert(m1_sel == m1_s) else begin
        $display("The select signal of m1 is wrong.");
        $display("Expected value = %h", m1_s);
        $display("Actual value   = %h", m1_sel);
        //$stop;
    end
        
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
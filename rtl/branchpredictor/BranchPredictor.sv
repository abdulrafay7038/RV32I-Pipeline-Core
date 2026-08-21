module BranchPredictor (
    input  logic        CLK,
    input  logic        RST,
    input  logic        Branch_taken,
    input  logic [31:0] InstE,
    input  logic [31:0] PCF,
    input  logic [31:0] PCE,
    input  logic [31:0] PCTargetE,
    input  logic [1: 0] predictionE,
    output logic [31:0] PCin,
    output logic [1: 0] predictionF
);

    wire logic Branchop, btb_hit, bht_hit, m1_sel;
    wire logic [1:0] UpdatedPrediction;
    wire logic [31:0] TargetAddress;

    bht BHT(
        .CLK(CLK),
        .RST(RST),
        .WE(Branchop),
        .PCF(PCF),
        .PCE(PCE),
        .updated_prediction(UpdatedPrediction),
        .predictionF(predictionF),
        .hit(bht_hit)
    );

    btb BTB(
        .CLK(CLK),
        .RST(RST),
        .WE(Branchop),
        .PCF(PCF),
        .PCE(PCE),
        .actual_address(PCTargetE),
        .target_address(TargetAddress),
        .hit(btb_hit)
    );

    counter Counter(
        .predictionE(predictionE),
        .Branch_taken(Branch_taken),
        .branchop(Branchop),
        .updated_prediction(UpdatedPrediction)
    );

    assign Branchop = (InstE[6:0] == 7'b1100011);
    assign m1_sel   = (bht_hit & btb_hit & predictionF[1]);
    assign PCin     = m1_sel ? TargetAddress : (PCF + 32'd4);
endmodule
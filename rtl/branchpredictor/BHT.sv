module BHT(
    input  logic        CLK,
    input  logic        RST,
    input  logic        WE,

    input  logic [31:0] PCF,                //PC being fetched
    input  logic [31:0] PCE,                //PC being executed
    input  logic [1:0]  updated_prediction, //updated prediction from counter

    output logic [1:0]  predictionF,       //stored prediction for fetched pc
    output logic        hit
);

    logic [24:0] bht [255:0];   //256 entries in table each 25 bit wide, 22 tag bits + 2 bits for prediction, 1 bit for valid
    logic [7:0]  indexF;
    logic [7:0]  indexE;
    logic [21:0] tagF;
    logic [21:0] tagE;
    logic [21:0] stored_tag;
    logic valid;

    //Decode
    assign tagF   = PCF[31:10];
    assign tagE   = PCE[31:10];
    assign indexE = PCE[9:2];
    assign indexF = PCF[9:2];

    assign stored_tag = bht[indexF][23:2];
    assign valid      = bht[indexF][24];

    //Write Interface
    always_ff @(posedge CLK or posedge RST) begin
        if (RST) begin
            for (int i = 0; i < 256; i++) begin
                bht[i][24]  <= 1'b0;                   //Initializing all valids to 0
                bht[i][1:0] <= 2'b01;
            end
        end
        else if (WE) begin
            bht[indexE][1:0]   <= updated_prediction;
            bht[indexE][23:2]  <= tagE;
            bht[indexE][24]    <= 1'b1;
        end

    end
    
    //Read Interface
    always_comb begin
        predictionF    = bht[indexF][1:0];
        hit            = (tagF == stored_tag) && valid;
    end

endmodule

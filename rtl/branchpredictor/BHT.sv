module BHT (
    input  var logic        clk,
    input  var logic        rst,
    input  var logic        write,
    input  var logic [31:0] pc1,   // PC to fetch
    input  var logic [31:0] pc2,
    input  var logic [31:0] inst,
    input  var logic [ 1:0] updated_logic,
    output var logic [ 1:0] prediction,
    output var logic        read
);
    var logic [23:0] bht [0:255];
    var logic [21:0] tag1;
    var logic [ 7:0] index1;
    var logic [21:0] tag2;
    var logic [ 7:0] index2;

//READ LOGIC
    always_comb begin
        // TODO
    end

//ASSIGN TAG AND INDEX
    always_comb begin
        // TODO
    end

//PREDICTION
    always_comb begin
        // TODO
    end 

//UPDATE
    always_ff @(posedge clk) begin
        // TODO
    end
    
endmodule
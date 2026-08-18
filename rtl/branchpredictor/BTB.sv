module BTB(
    input  var logic        clk,
    input  var logic        rst,
    input  var logic        read,
    input  var logic [31:0] pc1,
    input  var logic [31:0] pc2,
    input  var logic [31:0] target_address,
    input  var logic        actual,
    input  var logic [1:0]  prediction,
    output var logic [31:0] pc_in
);

    var logic [53:0] btb [255:0];
    var logic [21:0] tag1;
    var logic [ 7:0] index1;
    var logic [21:0] tag2;
    var logic [ 7:0] index2;

//ASSIGN TAG AND INDEX
    always_comb begin
        // TODO
    end

//GET TARGET ADDRESS
    always_comb  begin
        // TODO
    end

//WRITE OR REMOVE
    always_ff @(negedge clk) begin
        // TODO
    end
endmodule
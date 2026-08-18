module controller (
    input  var logic        clk,
    input  var logic        rst,
    input  var logic [31:0] pc1,
    input  var logic [31:0] instq1,
    input  var logic        branch,
    input  var logic        actual,
    input  var logic        actual1,
    input  var logic [ 1:0] prediction,
    input  var logic        read,
    output var logic        flush,
    output var logic [ 1:0] m1_sel,
    output var logic [ 1:0] updated_logic,
    output var logic        write
);

    var logic [1:0] current_state;
    var logic [1:0] next_state;

//WRITE SIGNAL TO BHT
    always_ff @(posedge clk) begin  
        // TODO
    end

//FLUSH SIGNAL TO PIPELINE
    always_comb begin
        // TODO
    end

//SELECTION FROM MUX BEFORE PC TO PIPELINE
    always_comb begin
        // TODO
    end

//UPDATED PREDICTION TO BHT
    //FSM
    logic [1:0] SNT            = 2'b00; 
    logic [1:0] WNT            = 2'b01; 
    logic [1:0] WT             = 2'b10; 
    logic [1:0] ST             = 2'b11;
    logic [1:0] CS, NS;

    always_ff@(posedge clk or posedge rst)   // FF
    begin
        // TODO
    end

    always_comb begin                        // NEXT STATE LOGIC
        // TODO
    end

    always_comb begin                        // OUTPUT LOGIC
        // TODO
    end
endmodule
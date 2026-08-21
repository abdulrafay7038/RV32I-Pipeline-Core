module btb(
    input  logic        CLK,
    input  logic        RST,
    input  logic        WE,   // write-enable

    input  logic [31:0] PCF,  // to read BTB during fetch
    input  logic [31:0] PCE,  // to write BTB during execute
    input  logic [31:0] actual_address,  //Branch target calculated during execute

    output logic [31:0] target_address,  //target address saved in BTB
    output logic        hit                 

);
    logic [54:0] btb [255:0];   //256 entries in table each 55 bit wide, 22 tag bits + 32 bits for target address, 1 bit for valid
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

    assign stored_tag = btb[indexF][53:32];
    assign valid      = btb[indexF][54];

    //Write Interface
    always_ff @(posedge CLK or posedge RST) begin
        if (RST) begin
            for (int i = 0; i < 256; i++) begin
                btb[i][54] <= 1'b0;                   //Initializing all valids to 0
            end
        end
        else if (WE) begin
            btb[indexE][31:0]  <= actual_address;
            btb[indexE][53:32] <= tagE;
            btb[indexE][54]    <= 1'b1;
        end

    end
    
    //Read Interface
    always_comb begin
        target_address = btb[indexF][31:0];
        hit            = (tagF == stored_tag) && valid;
    end


endmodule
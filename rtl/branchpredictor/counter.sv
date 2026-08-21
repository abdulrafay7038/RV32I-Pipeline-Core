module counter (
    input  logic [1:0] predictionE,
    input  logic       Branch_taken,
    input  logic       branchop,
    output logic [1:0] updated_prediction
);
    logic T, NT;
    logic [1:0] NS;

    logic [1:0] SNT            = 2'b00; 
    logic [1:0] WNT            = 2'b01; 
    logic [1:0] WT             = 2'b10; 
    logic [1:0] ST             = 2'b11;
    
    always_comb begin
        T  = 1'b0;
        NT = 1'b0;
        if (branchop) begin
            if (Branch_taken)
                T  = 1'b1;
            else
                NT = 1'b1;
        end
    end

    // Next state logic
    always_comb begin
        NS = predictionE;

        case (predictionE)
        SNT: begin
            if (T) begin
                NS = WNT;
            end
            else begin
                NS = SNT;
            end
        end

        WNT: begin
            if (T) 
                NS = WT;
            else if (NT) 
                NS = SNT;
        end

        WT: begin
            if (T) 
                NS = ST;
            else if (NT) 
                NS = WNT;
        end

        ST: begin
            if (T) 
                NS = ST;
            else if (NT) 
                NS = WT;
        end
        endcase
    end
    assign updated_prediction = NS;
endmodule
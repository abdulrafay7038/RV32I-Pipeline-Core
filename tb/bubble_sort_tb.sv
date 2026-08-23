module bubblesort_tb;

    logic clk;
    logic rst;

    top DUT (
        .CLK(clk),
        .RST(rst)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("bubblesort.vcd");
        $dumpvars(0, bubblesort_tb);
        clk = 1;
        rst = 1;
        $readmemh("../program/machinecode/bubblesort.hex", DUT.Datapath.InstrMem.mem);
        $readmemh("../program/machinecode/datamem.hex", DUT.Datapath.DataMem.data_mem);
        // Hold reset for one clock cycles
        @(posedge clk);
        rst = 0;
        @(negedge clk) DUT.Datapath.Regfile.x[2] = 4095; // Initialize Stack Pointer
        #5000000;

        for (int i = 0; i < 255; i++) begin

            logic [31:0] word_i;
            logic [31:0] word_next;

            word_i = {
                DUT.Datapath.DataMem.data_mem[i*4+3],
                DUT.Datapath.DataMem.data_mem[i*4+2],
                DUT.Datapath.DataMem.data_mem[i*4+1],
                DUT.Datapath.DataMem.data_mem[i*4+0]
            };

            word_next = {
                DUT.Datapath.DataMem.data_mem[(i+1)*4+3],
                DUT.Datapath.DataMem.data_mem[(i+1)*4+2],
                DUT.Datapath.DataMem.data_mem[(i+1)*4+1],
                DUT.Datapath.DataMem.data_mem[(i+1)*4+0]
            };

            if (word_i > word_next) begin
                $fatal(
                    1,
                    "BUBBLESORT FAILED: word[%0d] = %0d > word[%0d] = %0d",
                    i,
                    word_i,
                    i+1,
                    word_next
                );
        end
    end
            $display("----------------------------------------");
            $display("BUBBLESORT PASSED");
            $display("First 256 words are sorted.");
            $display("----------------------------------------");

            $finish;
end
endmodule        
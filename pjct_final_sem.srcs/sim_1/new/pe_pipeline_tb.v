module pe_pipeline_tb;

reg clk, reset, enable;
reg [15:0] a, b;
wire [31:0] result;

pe_pipeline uut (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a(a),
    .b(b),
    .result(result)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    enable = 0;
    a = 0; b = 0;

    #10 reset = 0;

    @(posedge clk);
    enable = 1; a = 2; b = 3;

    @(posedge clk);
    a = 4; b = 5;

    @(posedge clk); 
a = 1; b = 6;

// DO NOT disable yet
@(posedge clk); // second multiplication happens

// Flush cycle (IMPORTANT)
@(posedge clk);

// NOW disable
enable = 0;
a = 0; b = 0;

@(posedge clk);

    // Flush pipeline
    @(posedge clk);

    #20 $stop;
end

endmodule
module pe_tb;

reg clk;
reg reset;
reg enable;
reg [15:0] a, b;
wire [31:0] result;

pe_unit uut (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a(a),
    .b(b),
    .result(result)
);

// clock generation
always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    enable = 0;
    a = 0;
    b = 0;

    #12 reset = 0;

    @(posedge clk);
    a = 2; b = 3; enable = 1;

    @(posedge clk);
    a = 4; b = 5; enable = 1;

    @(posedge clk);
    a = 1; b = 6; enable = 0;

    @(posedge clk);
    a = 2; b = 1; enable = 0;

    @(posedge clk);
    a = 3; b = 3; enable = 1;

    #20 $stop;
end
endmodule
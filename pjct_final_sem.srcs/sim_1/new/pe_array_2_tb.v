module pe_array_2_tb;

reg clk;
reg reset;
reg enable;

reg [15:0] a0, a1;
reg [15:0] b0, b1, b2, b3;

wire [31:0] result0, result1;

pe_array_2 uut (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a0(a0), .a1(a1),
    .b0(b0), .b1(b1), .b2(b2), .b3(b3),
    .result0(result0),
    .result1(result1)
);

// clock
always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    enable = 0;

    #10 reset = 0;

    @(posedge clk);
    enable = 1;
    a0 = 2; b0 = 3;   // PE0 → 6
    a1 = 4; b1 = 5;   // PE1 → 20

    @(posedge clk);
    enable = 1;
    a0 = 1; b0 = 6;   // PE0 → +6 → 12
    a1 = 2; b1 = 2;   // PE1 → +4 → 24

    @(posedge clk);
    enable = 0;

    #20 $stop;
end

endmodule
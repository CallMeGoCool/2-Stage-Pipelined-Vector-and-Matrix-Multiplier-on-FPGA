module vector_dot_tb;

reg clk, reset, start;

reg [15:0] a0,a1,a2,a3;
reg [15:0] b0,b1,b2,b3;

wire [31:0] result;
wire done;

vector_dot uut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .a0(a0), .a1(a1), .a2(a2), .a3(a3),
    .b0(b0), .b1(b1), .b2(b2), .b3(b3),
    .result(result),
    .done(done)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    start = 0;

    #10 reset = 0;

    // A = [1 2 3 4]
    // B = [5 6 7 8]
    a0=1; a1=2; a2=3; a3=4;
    b0=5; b1=6; b2=7; b3=8;

    @(posedge clk);
    start = 1;

    @(posedge clk);
    start = 0;

    wait(done);

    #20 $stop;
end

endmodule
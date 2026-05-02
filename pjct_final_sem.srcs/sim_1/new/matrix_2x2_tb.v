module matrix_2x2_tb;

reg clk;
reg reset;
reg start;

reg [15:0] a00, a01, a10, a11;
reg [15:0] b00, b01, b10, b11;

wire [31:0] c00, c01, c10, c11;
wire done;

matrix_2x2 uut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .a00(a00), .a01(a01), .a10(a10), .a11(a11),
    .b00(b00), .b01(b01), .b10(b10), .b11(b11),
    .c00(c00), .c01(c01), .c10(c10), .c11(c11),
    .done(done)
);

// clock
always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    start = 0;

    #10 reset = 0;

    // matrices
    a00=1; a01=2;
    a10=3; a11=4;

    b00=5; b01=6;
    b10=7; b11=8;

    @(posedge clk);
    start = 1;

    @(posedge clk);
    start = 0;

    wait(done);

    #20 $stop;
end

endmodule
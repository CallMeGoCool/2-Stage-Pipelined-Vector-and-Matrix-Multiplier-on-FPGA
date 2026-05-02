module mac_tb;

reg clk;
reg reset;
reg [15:0] a, b;
wire [31:0] result;

mac_unit uut (
    .clk(clk),
    .reset(reset),
    .a(a),
    .b(b),
    .result(result)
);

// clock generation
always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    a = 0;
    b = 0;

    #10 reset = 0;

    a = 2; b = 3; #10;
    a = 4; b = 5; #10;
    a = 1; b = 6; #10;

    #20 $stop;
end

endmodule
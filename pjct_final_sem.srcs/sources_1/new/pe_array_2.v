module pe_array_2(
    input clk,
    input reset,
    input enable,

    input [15:0] a0, a1,
    input [15:0] b0, b1, b2, b3,

    output [31:0] result0,
    output [31:0] result1
);

// PE 1 → computes C0
pe_unit pe0 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a(a0),
    .b(b0),
    .result(result0)
);

// PE 2 → computes C1
pe_unit pe1 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .a(a1),
    .b(b1),
    .result(result1)
);

endmodule
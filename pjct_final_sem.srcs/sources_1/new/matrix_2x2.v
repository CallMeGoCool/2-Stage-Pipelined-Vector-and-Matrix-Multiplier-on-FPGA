module matrix_2x2(
    input clk,
    input reset,
    input start,

    input [15:0] a00, a01, a10, a11,
    input [15:0] b00, b01, b10, b11,

    output [31:0] c00, c01, c10, c11,
    output done
);

// Controller signals
wire valid, phase;

controller ctrl (
    .clk(clk),
    .reset(reset),
    .start(start),
    .valid(valid),
    .phase(phase),
    .done(done)
);

// Inputs to PEs
wire [15:0] a0_0, a0_1, a1_0, a1_1;
wire [15:0] b0_0, b0_1, b1_0, b1_1;

// Input selection
assign a0_0 = (phase == 0) ? a00 : a01;
assign b0_0 = (phase == 0) ? b00 : b10;

assign a0_1 = (phase == 0) ? a00 : a01;
assign b0_1 = (phase == 0) ? b01 : b11;

assign a1_0 = (phase == 0) ? a10 : a11;
assign b1_0 = (phase == 0) ? b00 : b10;

assign a1_1 = (phase == 0) ? a10 : a11;
assign b1_1 = (phase == 0) ? b01 : b11;

// PEs
pe_pipeline pe00 (.clk(clk), .reset(reset), .valid_in(valid), .a(a0_0), .b(b0_0), .result(c00));
pe_pipeline pe01 (.clk(clk), .reset(reset), .valid_in(valid), .a(a0_1), .b(b0_1), .result(c01));
pe_pipeline pe10 (.clk(clk), .reset(reset), .valid_in(valid), .a(a1_0), .b(b1_0), .result(c10));
pe_pipeline pe11 (.clk(clk), .reset(reset), .valid_in(valid), .a(a1_1), .b(b1_1), .result(c11));

endmodule
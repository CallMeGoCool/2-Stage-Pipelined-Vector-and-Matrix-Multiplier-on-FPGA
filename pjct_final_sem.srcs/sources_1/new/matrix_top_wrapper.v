module matrix_top_wrapper(
    input clk,
    input [15:0] sw,
    input btnC, btnU, btnD, btnL, btnR,

    output [15:0] led,
    output [7:0] seg,
    output [7:0] an
);

wire [1:0] mode = sw[1:0];

// ---------------- INPUT STORAGE WIRES ----------------
wire [15:0] A0,A1,A2,A3,A4,A5,A6,A7;
wire [15:0] A8,A9,A10,A11,A12,A13,A14,A15;

wire [15:0] B0,B1,B2,B3,B4,B5,B6,B7;
wire [15:0] B8,B9,B10,B11,B12,B13,B14,B15;

wire start, reset;
wire [5:0] index;
wire [2:0] save_led;

// ---------------- INPUT CONTROLLER ----------------
input_controller ic (
    .clk(clk),
    .sw(sw[15:8]),
    .mode(mode),

    .btnC(btnC),
    .btnU(btnU),
    .btnD(btnD),
    .btnL(btnL),
    .btnR(btnR),

    .A0(A0), .A1(A1), .A2(A2), .A3(A3),
    .A4(A4), .A5(A5), .A6(A6), .A7(A7),
    .A8(A8), .A9(A9), .A10(A10), .A11(A11),
    .A12(A12), .A13(A13), .A14(A14), .A15(A15),

    .B0(B0), .B1(B1), .B2(B2), .B3(B3),
    .B4(B4), .B5(B5), .B6(B6), .B7(B7),
    .B8(B8), .B9(B9), .B10(B10), .B11(B11),
    .B12(B12), .B13(B13), .B14(B14), .B15(B15),

    .start(start),
    .reset(reset),
    .index(index),
    .save_led(save_led)
);

// ---------------- CORE ----------------
wire [31:0] out0,out1,out2,out3,out4,out5,out6,out7;
wire [31:0] out8,out9,out10,out11,out12,out13,out14,out15;
wire done_raw;

matrix_top core (
    .clk(clk),
    .reset(reset),
    .start(start),
    .mode(mode),

    .a0(A0), .a1(A1), .a2(A2), .a3(A3),
    .b0(B0), .b1(B1), .b2(B2), .b3(B3),

    .a00(A0), .a01(A1), .a02(A2), .a03(A3),
    .a10(A4), .a11(A5), .a12(A6), .a13(A7),
    .a20(A8), .a21(A9), .a22(A10), .a23(A11),
    .a30(A12), .a31(A13), .a32(A14), .a33(A15),

    .b00(B0), .b01(B1), .b02(B2), .b03(B3),
    .b10(B4), .b11(B5), .b12(B6), .b13(B7),
    .b20(B8), .b21(B9), .b22(B10), .b23(B11),
    .b30(B12), .b31(B13), .b32(B14), .b33(B15),

    .out0(out0), .out1(out1), .out2(out2), .out3(out3),
    .out4(out4), .out5(out5), .out6(out6), .out7(out7),
    .out8(out8), .out9(out9), .out10(out10), .out11(out11),
    .out12(out12), .out13(out13), .out14(out14), .out15(out15),

    .done(done_raw)
);

// ---------------- DONE LATCH (IMPORTANT FIX) ----------------
reg done_latched = 0;

always @(posedge clk) begin
    if (reset)
        done_latched <= 0;
    else if (done_raw)
        done_latched <= 1;
end

// ---------------- DISPLAY CONTROLLER ----------------
display_controller dc (
    .clk(clk),
    .done(done_latched),
    .index(index),

    .A0(A0), .A1(A1), .A2(A2), .A3(A3),
    .A4(A4), .A5(A5), .A6(A6), .A7(A7),

    .out0(out0), .out1(out1), .out2(out2), .out3(out3),
    .out4(out4), .out5(out5), .out6(out6), .out7(out7),

    .seg(seg),
    .an(an)
);

// ---------------- LED DEBUG ----------------
assign led[2:0]  = save_led;
assign led[7:3]  = index[4:0];
assign led[14]   = done_raw;
assign led[15]   = done_latched;

endmodule
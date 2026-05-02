module matrix_top(
    input clk,
    input reset,
    input start,
    input [1:0] mode,

    // vector inputs
    input [15:0] a0,a1,a2,a3,
    input [15:0] b0,b1,b2,b3,

    // matrix inputs
    input [15:0] a00,a01,a02,a03,
    input [15:0] a10,a11,a12,a13,
    input [15:0] a20,a21,a22,a23,
    input [15:0] a30,a31,a32,a33,

    input [15:0] b00,b01,b02,b03,
    input [15:0] b10,b11,b12,b13,
    input [15:0] b20,b21,b22,b23,
    input [15:0] b30,b31,b32,b33,

    // unified outputs (FLAT)
    output reg [31:0] out0,out1,out2,out3,
    output reg [31:0] out4,out5,out6,out7,
    output reg [31:0] out8,out9,out10,out11,
    output reg [31:0] out12,out13,out14,out15,

    output reg done
);

// ---------------- START CONTROL ----------------
wire start_vec = (mode == 2'b01) ? start : 0;
wire start_2x2 = (mode == 2'b10) ? start : 0;
wire start_4x4 = (mode == 2'b11) ? start : 0;

// ---------------- VECTOR ----------------
wire [31:0] vec_result;
wire done_vec;

vector_dot v1 (
    .clk(clk), .reset(reset), .start(start_vec),
    .a0(a0), .a1(a1), .a2(a2), .a3(a3),
    .b0(b0), .b1(b1), .b2(b2), .b3(b3),
    .result(vec_result),
    .done(done_vec)
);

// ---------------- 2x2 ----------------
wire [31:0] c00_2,c01_2,c10_2,c11_2;
wire done_2;

matrix_2x2 m2 (
    .clk(clk), .reset(reset), .start(start_2x2),
    .a00(a00), .a01(a01), .a10(a10), .a11(a11),
    .b00(b00), .b01(b01), .b10(b10), .b11(b11),
    .c00(c00_2), .c01(c01_2),
    .c10(c10_2), .c11(c11_2),
    .done(done_2)
);

// ---------------- 4x4 ----------------
wire [31:0] c00,c01,c02,c03;
wire [31:0] c10,c11,c12,c13;
wire [31:0] c20,c21,c22,c23;
wire [31:0] c30,c31,c32,c33;
wire done_4;

matrix_4x4_full m4 (
    .clk(clk), .reset(reset), .start(start_4x4),

    .a00(a00),.a01(a01),.a02(a02),.a03(a03),
    .a10(a10),.a11(a11),.a12(a12),.a13(a13),
    .a20(a20),.a21(a21),.a22(a22),.a23(a23),
    .a30(a30),.a31(a31),.a32(a32),.a33(a33),

    .b00(b00),.b01(b01),.b02(b02),.b03(b03),
    .b10(b10),.b11(b11),.b12(b12),.b13(b13),
    .b20(b20),.b21(b21),.b22(b22),.b23(b23),
    .b30(b30),.b31(b31),.b32(b32),.b33(b33),

    .c00(c00),.c01(c01),.c02(c02),.c03(c03),
    .c10(c10),.c11(c11),.c12(c12),.c13(c13),
    .c20(c20),.c21(c21),.c22(c22),.c23(c23),
    .c30(c30),.c31(c31),.c32(c32),.c33(c33),

    .done(done_4)
);

// ---------------- OUTPUT MUX ----------------
always @(*) begin
    // default
    out0=0; out1=0; out2=0; out3=0;
    out4=0; out5=0; out6=0; out7=0;
    out8=0; out9=0; out10=0; out11=0;
    out12=0; out13=0; out14=0; out15=0;
    done=0;

    case(mode)

    // VECTOR
    2'b01: begin
        out0 = vec_result;
        done = done_vec;
    end

    // 2x2
    2'b10: begin
        out0=c00_2; out1=c01_2;
        out2=c10_2; out3=c11_2;
        done = done_2;
    end

    // 4x4
    2'b11: begin
        out0=c00; out1=c01; out2=c02; out3=c03;
        out4=c10; out5=c11; out6=c12; out7=c13;
        out8=c20; out9=c21; out10=c22; out11=c23;
        out12=c30; out13=c31; out14=c32; out15=c33;
        done = done_4;
    end

    endcase
end

endmodule
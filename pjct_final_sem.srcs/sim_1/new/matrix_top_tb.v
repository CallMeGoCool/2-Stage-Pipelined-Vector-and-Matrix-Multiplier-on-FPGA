module matrix_top_tb;

reg clk, reset, start;
reg [1:0] mode;

// vector inputs
reg [15:0] a0=1,a1=2,a2=3,a3=4;
reg [15:0] b0=5,b1=6,b2=7,b3=8;

// matrix inputs
reg [15:0] a00=1,a01=2,a02=3,a03=4;
reg [15:0] a10=5,a11=6,a12=7,a13=8;
reg [15:0] a20=1,a21=1,a22=1,a23=1;
reg [15:0] a30=2,a31=2,a32=2,a33=2;

reg [15:0] b00=1,b01=0,b02=0,b03=0;
reg [15:0] b10=0,b11=1,b12=0,b13=0;
reg [15:0] b20=0,b21=0,b22=1,b23=0;
reg [15:0] b30=0,b31=0,b32=0,b33=1;

// outputs (FLAT - FIXED)
wire [31:0] out0,out1,out2,out3;
wire [31:0] out4,out5,out6,out7;
wire [31:0] out8,out9,out10,out11;
wire [31:0] out12,out13,out14,out15;

wire done;

// DUT
matrix_top uut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .mode(mode),

    // vector
    .a0(a0),.a1(a1),.a2(a2),.a3(a3),
    .b0(b0),.b1(b1),.b2(b2),.b3(b3),

    // matrix A
    .a00(a00),.a01(a01),.a02(a02),.a03(a03),
    .a10(a10),.a11(a11),.a12(a12),.a13(a13),
    .a20(a20),.a21(a21),.a22(a22),.a23(a23),
    .a30(a30),.a31(a31),.a32(a32),.a33(a33),

    // matrix B
    .b00(b00),.b01(b01),.b02(b02),.b03(b03),
    .b10(b10),.b11(b11),.b12(b12),.b13(b13),
    .b20(b20),.b21(b21),.b22(b22),.b23(b23),
    .b30(b30),.b31(b31),.b32(b32),.b33(b33),

    // outputs
    .out0(out0), .out1(out1), .out2(out2), .out3(out3),
    .out4(out4), .out5(out5), .out6(out6), .out7(out7),
    .out8(out8), .out9(out9), .out10(out10), .out11(out11),
    .out12(out12), .out13(out13), .out14(out14), .out15(out15),

    .done(done)
);

// clock
always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    start = 0;
    mode = 2'b00;

    #10 reset = 0;

    // ================= VECTOR =================
    $display("---- VECTOR TEST ----");
    mode = 2'b01;

    #10 start = 1;
    #10 start = 0;

    wait(done);
    $display("Vector Result = %d (Expected: 70)", out0);

    #20;

    // ================= 2x2 =================
    $display("---- 2x2 TEST ----");
    mode = 2'b10;

    #10 start = 1;
    #10 start = 0;

    wait(done);
    $display("2x2 Output:");
    $display("%d %d", out0, out1);
    $display("%d %d", out2, out3);

    #20;

    // ================= 4x4 =================
    $display("---- 4x4 TEST ----");
    mode = 2'b11;

    #10 start = 1;
    #10 start = 0;

    wait(done);
    $display("4x4 Output:");
    $display("%d %d %d %d", out0, out1, out2, out3);
    $display("%d %d %d %d", out4, out5, out6, out7);
    $display("%d %d %d %d", out8, out9, out10, out11);
    $display("%d %d %d %d", out12, out13, out14, out15);

    #50 $stop;
end

endmodule
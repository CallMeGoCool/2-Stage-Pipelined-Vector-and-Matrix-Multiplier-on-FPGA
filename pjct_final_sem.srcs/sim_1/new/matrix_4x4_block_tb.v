module matrix_4x4_block_tb;

reg clk, reset, start;

// Same matrices as before
reg [15:0] a00=1,a01=2,a02=3,a03=4;
reg [15:0] a10=5,a11=6,a12=7,a13=8;
reg [15:0] a20=1,a21=1,a22=1,a23=1;
reg [15:0] a30=2,a31=2,a32=2,a33=2;

reg [15:0] b00=1,b01=0,b02=0,b03=0;
reg [15:0] b10=0,b11=1,b12=0,b13=0;
reg [15:0] b20=0,b21=0,b22=1,b23=0;
reg [15:0] b30=0,b31=0,b32=0,b33=1;

wire done;

wire [31:0] c00,c01,c02,c03;
wire [31:0] c10,c11,c12,c13;
wire [31:0] c20,c21,c22,c23;
wire [31:0] c30,c31,c32,c33;

// Instantiate NEW module
matrix_4x4_full uut (
    .clk(clk), .reset(reset), .start(start),

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

    .done(done)
);

// Clock
always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    start = 0;

    #10 reset = 0;

    // Proper start pulse
    @(posedge clk);
    start = 1;

    @(posedge clk);
    start = 0;

    // Wait for completion
    wait(done);

    #50 $stop;
end

endmodule
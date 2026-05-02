module matrix_4x4_full(
    input clk,
    input reset,
    input start,

    // A matrix
    input [15:0] a00,a01,a02,a03,
    input [15:0] a10,a11,a12,a13,
    input [15:0] a20,a21,a22,a23,
    input [15:0] a30,a31,a32,a33,

    // B matrix
    input [15:0] b00,b01,b02,b03,
    input [15:0] b10,b11,b12,b13,
    input [15:0] b20,b21,b22,b23,
    input [15:0] b30,b31,b32,b33,

    // Output matrix
    output reg [31:0] c00,c01,c02,c03,
    output reg [31:0] c10,c11,c12,c13,
    output reg [31:0] c20,c21,c22,c23,
    output reg [31:0] c30,c31,c32,c33,

    output reg done
);

// control
reg start_2x2, reset_2x2;
wire done_2x2;

// temp wires
wire [31:0] t00,t01,t10,t11;

// temp storage
reg [31:0] temp00,temp01,temp10,temp11;

// inputs to 2x2
reg [15:0] A00,A01,A10,A11;
reg [15:0] B00,B01,B10,B11;

// instantiate 2x2
matrix_2x2 m2 (
    .clk(clk),
    .reset(reset_2x2),
    .start(start_2x2),
    .a00(A00), .a01(A01), .a10(A10), .a11(A11),
    .b00(B00), .b01(B01), .b10(B10), .b11(B11),
    .c00(t00), .c01(t01), .c10(t10), .c11(t11),
    .done(done_2x2)
);

// FSM
reg [5:0] state;

parameter IDLE=0,

// C11
S1=1,S2=2,S3=3,S4=4,S5=5,

// C12
S6=6,S7=7,S8=8,S9=9,S10=10,

// C21
S11=11,S12=12,S13=13,S14=14,S15=15,

// C22
S16=16,S17=17,S18=18,S19=19,S20=20,S21=21,S22=22,S23=23;

always @(posedge clk or posedge reset) begin
if(reset) begin
    state<=IDLE;
    done<=0;
    start_2x2<=0;
    reset_2x2<=1;

    c00<=0; c01<=0; c02<=0; c03<=0;
    c10<=0; c11<=0; c12<=0; c13<=0;
    c20<=0; c21<=0; c22<=0; c23<=0;
    c30<=0; c31<=0; c32<=0; c33<=0;
end
else begin
case(state)

// ---------------- IDLE ----------------
IDLE: begin
    done<=0;
    reset_2x2<=1;
    if(start) state<=S1;
end

// ---------------- C11 ----------------
S1: begin reset_2x2<=0;
    A00<=a00; A01<=a01; A10<=a10; A11<=a11;
    B00<=b00; B01<=b01; B10<=b10; B11<=b11;
    start_2x2<=1; state<=S2;
end

S2: begin start_2x2<=0;
    if(done_2x2) begin
        temp00<=t00; temp01<=t01; temp10<=t10; temp11<=t11;
        state<=S3;
    end
end

S3: begin reset_2x2<=1; state<=S4; end

S4: begin reset_2x2<=0;
    A00<=a02; A01<=a03; A10<=a12; A11<=a13;
    B00<=b20; B01<=b21; B10<=b30; B11<=b31;
    start_2x2<=1; state<=S5;
end

S5: begin start_2x2<=0;
    if(done_2x2) begin
        c00<=temp00+t00;
        c01<=temp01+t01;
        c10<=temp10+t10;
        c11<=temp11+t11;
        state<=S6;
    end
end

// ---------------- C12 ----------------
S6: begin reset_2x2<=1; state<=S7; end

S7: begin reset_2x2<=0;
    A00<=a00; A01<=a01; A10<=a10; A11<=a11;
    B00<=b02; B01<=b03; B10<=b12; B11<=b13;
    start_2x2<=1; state<=S8;
end

S8: begin start_2x2<=0;
    if(done_2x2) begin
        temp00<=t00; temp01<=t01; temp10<=t10; temp11<=t11;
        state<=S9;
    end
end

S9: begin reset_2x2<=1; state<=S10; end

S10: begin reset_2x2<=0;
    A00<=a02; A01<=a03; A10<=a12; A11<=a13;
    B00<=b22; B01<=b23; B10<=b32; B11<=b33;
    start_2x2<=1; state<=S11;
end

S11: begin start_2x2<=0;
    if(done_2x2) begin
        c02<=temp00+t00;
        c03<=temp01+t01;
        c12<=temp10+t10;
        c13<=temp11+t11;
        state<=S12;
    end
end

// ---------------- C21 ----------------
S12: begin reset_2x2<=1; state<=S13; end

S13: begin reset_2x2<=0;
    A00<=a20; A01<=a21; A10<=a30; A11<=a31;
    B00<=b00; B01<=b01; B10<=b10; B11<=b11;
    start_2x2<=1; state<=S14;
end

S14: begin start_2x2<=0;
    if(done_2x2) begin
        temp00<=t00; temp01<=t01; temp10<=t10; temp11<=t11;
        state<=S15;
    end
end

S15: begin reset_2x2<=1; state<=S16; end

S16: begin reset_2x2<=0;
    A00<=a22; A01<=a23; A10<=a32; A11<=a33;
    B00<=b20; B01<=b21; B10<=b30; B11<=b31;
    start_2x2<=1; state<=S17;
end

S17: begin start_2x2<=0;
    if(done_2x2) begin
        c20<=temp00+t00;
        c21<=temp01+t01;
        c30<=temp10+t10;
        c31<=temp11+t11;
        state<=S18;
    end
end

// ---------------- C22 ----------------
S18: begin reset_2x2<=1; state<=S19; end

S19: begin reset_2x2<=0;
    A00<=a20; A01<=a21; A10<=a30; A11<=a31;
    B00<=b02; B01<=b03; B10<=b12; B11<=b13;
    start_2x2<=1; state<=S20;
end

S20: begin start_2x2<=0;
    if(done_2x2) begin
        temp00<=t00; temp01<=t01; temp10<=t10; temp11<=t11;
        state<=S21;
    end
end

S21: begin reset_2x2<=1; state<=S22; end

S22: begin reset_2x2<=0;
    A00<=a22; A01<=a23; A10<=a32; A11<=a33;
    B00<=b22; B01<=b23; B10<=b32; B11<=b33;
    start_2x2<=1; state<=S23;
end

S23: begin start_2x2<=0;
    if(done_2x2) begin
        c22<=temp00+t00;
        c23<=temp01+t01;
        c32<=temp10+t10;
        c33<=temp11+t11;

        done<=1;
        state<=IDLE;
    end
end

endcase
end
end

endmodule
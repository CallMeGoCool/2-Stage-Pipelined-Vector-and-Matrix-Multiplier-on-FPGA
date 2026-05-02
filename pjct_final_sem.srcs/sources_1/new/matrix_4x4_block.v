module matrix_4x4_block(
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

    // Output (only C11 block for now)
    output reg [31:0] c00,c01,c02,c03,
    output reg [31:0] c10,c11,c12,c13,
    output reg [31:0] c20,c21,c22,c23,
    output reg [31:0] c30,c31,c32,c33,

    output reg done
);

// FSM
reg [3:0] state;

// control signals
reg start_2x2;
reg reset_2x2;
wire done_2x2;

// temp outputs from 2x2
wire [31:0] t00,t01,t10,t11;

// temp storage
reg [31:0] temp_c00, temp_c01, temp_c10, temp_c11;

// input regs for 2x2
reg [15:0] A00,A01,A10,A11;
reg [15:0] B00,B01,B10,B11;

// instantiate EXISTING matrix_2x2
matrix_2x2 m2 (
    .clk(clk),
    .reset(reset_2x2),   // IMPORTANT FIX
    .start(start_2x2),

    .a00(A00), .a01(A01), .a10(A10), .a11(A11),
    .b00(B00), .b01(B01), .b10(B10), .b11(B11),

    .c00(t00), .c01(t01), .c10(t10), .c11(t11),
    .done(done_2x2)
);

// states
parameter IDLE=0,
          LOAD1=1, START1=2, WAIT1=3,
          RESET2=4,
          LOAD2=5, START2=6, WAIT2=7,
          DONE=8;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        start_2x2 <= 0;
        reset_2x2 <= 1;
        done <= 0;

        c00<=0; c01<=0; c10<=0; c11<=0;

        temp_c00<=0; temp_c01<=0;
        temp_c10<=0; temp_c11<=0;

    end else begin
        case(state)

        // ---------------- IDLE ----------------
        IDLE: begin
            done <= 0;
            reset_2x2 <= 1;
            if (start)
                state <= LOAD1;
        end

        // -------- FIRST MULTIPLICATION --------
        LOAD1: begin
            reset_2x2 <= 0;

            // A11 × B11
            A00<=a00; A01<=a01; A10<=a10; A11<=a11;
            B00<=b00; B01<=b01; B10<=b10; B11<=b11;

            state <= START1;
        end

        START1: begin
            start_2x2 <= 1;
            state <= WAIT1;
        end

        WAIT1: begin
            start_2x2 <= 0;
            if (done_2x2) begin
                // store first result
                temp_c00 <= t00;
                temp_c01 <= t01;
                temp_c10 <= t10;
                temp_c11 <= t11;

                state <= RESET2;
            end
        end

        // -------- RESET BEFORE SECOND RUN --------
        RESET2: begin
            reset_2x2 <= 1;   // clear PE accumulators
            state <= LOAD2;
        end

        // -------- SECOND MULTIPLICATION --------
        LOAD2: begin
            reset_2x2 <= 0;

            // A12 × B21
            A00<=a02; A01<=a03; A10<=a12; A11<=a13;
            B00<=b20; B01<=b21; B10<=b30; B11<=b31;

            state <= START2;
        end

        START2: begin
            start_2x2 <= 1;
            state <= WAIT2;
        end

        WAIT2: begin
            start_2x2 <= 0;
            if (done_2x2) begin
                // FINAL result
                c00 <= temp_c00 + t00;
                c01 <= temp_c01 + t01;
                c10 <= temp_c10 + t10;
                c11 <= temp_c11 + t11;

                state <= DONE;
            end
        end

        // ---------------- DONE ----------------
        DONE: begin
            done <= 1;
            state <= IDLE;
        end

        endcase
    end
end

endmodule
module input_controller(
    input clk,
    input [7:0] sw,
    input [1:0] mode,

    input btnC, btnU, btnD, btnL, btnR,

    output reg [15:0] A0,A1,A2,A3,A4,A5,A6,A7,
    output reg [15:0] A8,A9,A10,A11,A12,A13,A14,A15,

    output reg [15:0] B0,B1,B2,B3,B4,B5,B6,B7,
    output reg [15:0] B8,B9,B10,B11,B12,B13,B14,B15,

    output reg start,
    output reg reset,

    output reg [5:0] index,
    output reg [2:0] save_led
);

reg btnC_prev, btnU_prev, btnD_prev, btnL_prev, btnR_prev;

wire btnC_pulse = btnC & ~btnC_prev;
wire btnU_pulse = btnU & ~btnU_prev;
wire btnD_pulse = btnD & ~btnD_prev;
wire btnL_pulse = btnL & ~btnL_prev;
wire btnR_pulse = btnR & ~btnR_prev;

reg start_reg;

wire [5:0] max_index =
    (mode == 2'b01) ? 7 :
    (mode == 2'b10) ? 7 :
    (mode == 2'b11) ? 31 : 0;

always @(posedge clk) begin
    btnC_prev <= btnC;
    btnU_prev <= btnU;
    btnD_prev <= btnD;
    btnL_prev <= btnL;
    btnR_prev <= btnR;

    if (btnD_pulse) begin
        index <= 0;
        reset <= 1;
        start_reg <= 0;
    end else begin
        reset <= 0;
    end

    if (btnR_pulse && index < max_index)
        index <= index + 1;

    if (btnL_pulse && index > 0)
        index <= index - 1;

    if (btnC_pulse) begin
        case(index)
            0:A0<=sw;1:A1<=sw;2:A2<=sw;3:A3<=sw;
            4:A4<=sw;5:A5<=sw;6:A6<=sw;7:A7<=sw;

            8:A8<=sw;9:A9<=sw;10:A10<=sw;11:A11<=sw;
            12:A12<=sw;13:A13<=sw;14:A14<=sw;15:A15<=sw;

            16:B0<=sw;17:B1<=sw;18:B2<=sw;19:B3<=sw;
            20:B4<=sw;21:B5<=sw;22:B6<=sw;23:B7<=sw;

            24:B8<=sw;25:B9<=sw;26:B10<=sw;27:B11<=sw;
            28:B12<=sw;29:B13<=sw;30:B14<=sw;31:B15<=sw;
        endcase

        save_led <= 3'b111;
    end else begin
        save_led <= 0;
    end

    if (btnU_pulse)
        start_reg <= 1;

    start <= start_reg;
end

endmodule
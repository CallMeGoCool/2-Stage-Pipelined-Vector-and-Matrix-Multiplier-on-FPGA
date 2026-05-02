module display_controller(
    input clk,
    input done,
    input [5:0] index,

    input [15:0] A0,A1,A2,A3,A4,A5,A6,A7,
    input [31:0] out0,out1,out2,out3,out4,out5,out6,out7,

    output [7:0] seg,
    output [7:0] an
);

reg [31:0] display_val;

always @(*) begin
    if (!done) begin
        case(index)
            0: display_val = A0;
            1: display_val = A1;
            2: display_val = A2;
            3: display_val = A3;
            4: display_val = A4;
            5: display_val = A5;
            6: display_val = A6;
            7: display_val = A7;
            default: display_val = 0;
        endcase
    end else begin
        case(index)
            0: display_val = out0;
            1: display_val = out1;
            2: display_val = out2;
            3: display_val = out3;
            4: display_val = out4;
            5: display_val = out5;
            6: display_val = out6;
            7: display_val = out7;
            default: display_val = 0;
        endcase
    end
end

seven_seg_driver disp (
    .clk(clk),
    .data(display_val),
    .seg(seg),
    .an(an)
);

endmodule
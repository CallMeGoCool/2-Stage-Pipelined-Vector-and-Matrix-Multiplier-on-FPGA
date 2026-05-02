module seven_seg_driver(
    input clk,
    input [31:0] data,

    output reg [7:0] seg,
    output reg [7:0] an
);

// ---------------- REFRESH ----------------
reg [2:0] digit = 0;
reg [19:0] refresh_counter = 0;

always @(posedge clk) begin
    refresh_counter <= refresh_counter + 1;
    digit <= refresh_counter[19:17];   // ~1kHz refresh
end

// ---------------- SELECT NIBBLE ----------------
reg [3:0] nibble;

always @(*) begin
    case(digit)
        0: nibble = data[3:0];
        1: nibble = data[7:4];
        2: nibble = data[11:8];
        3: nibble = data[15:12];
        4: nibble = data[19:16];
        5: nibble = data[23:20];
        6: nibble = data[27:24];
        7: nibble = data[31:28];
    endcase
end

// ---------------- DECODER (ACTIVE LOW) ----------------
always @(*) begin
    case(nibble)

        // NUMBERS
        4'h0: seg = 8'b11000000;
        4'h1: seg = 8'b11111001;
        4'h2: seg = 8'b10100100;
        4'h3: seg = 8'b10110000;
        4'h4: seg = 8'b10011001;
        4'h5: seg = 8'b10010010;
        4'h6: seg = 8'b10000010;
        4'h7: seg = 8'b11111000;
        4'h8: seg = 8'b10000000;
        4'h9: seg = 8'b10010000;

        // HEX / LETTERS (approx)
        4'hA: seg = 8'b10001000; // A (used as V approx)
        4'hB: seg = 8'b10000011; // b
        4'hC: seg = 8'b11000110; // C
        4'hD: seg = 8'b10100001; // d
        4'hE: seg = 8'b10000110; // E
        4'hF: seg = 8'b10001110; // F

        default: seg = 8'b11111111;
    endcase
end

// ---------------- ANODE CONTROL ----------------
always @(*) begin
    an = 8'b11111111;
    an[digit] = 0;
end

endmodule
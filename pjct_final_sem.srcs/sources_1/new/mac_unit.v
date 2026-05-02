module mac_unit(
    input clk,
    input reset,
    input [15:0] a,
    input [15:0] b,
    output reg [31:0] result
);

always @(posedge clk or posedge reset) begin
    if (reset)
        result <= 0;
    else
        result <= result + (a * b);
end

endmodule
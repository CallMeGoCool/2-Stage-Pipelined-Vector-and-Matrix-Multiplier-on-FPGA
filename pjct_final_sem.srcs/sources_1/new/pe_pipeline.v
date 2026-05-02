module pe_pipeline(
    input clk,
    input reset,
    input valid_in,
    input [15:0] a,
    input [15:0] b,
    output reg [31:0] result,
    output reg valid_out
);

reg [31:0] mult_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        mult_reg <= 0;
        result <= 0;
        valid_out <= 0;
    end else begin
        // Stage 1: multiply
        if (valid_in)
            mult_reg <= a * b;

        // Stage 2: accumulate
        if (valid_out)
            result <= result + mult_reg;

        // pipeline valid signal
        valid_out <= valid_in;
    end
end

endmodule
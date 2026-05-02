module vector_dot(
    input clk,
    input reset,
    input start,

    input [15:0] a0, a1, a2, a3,
    input [15:0] b0, b1, b2, b3,

    output [31:0] result,
    output done
);

reg [2:0] state;
reg [1:0] index;

reg valid_in;
reg [15:0] a_reg, b_reg;

wire [31:0] pe_result;
wire valid_out;

pe_pipeline pe (
    .clk(clk),
    .reset(reset),
    .valid_in(valid_in),
    .a(a_reg),
    .b(b_reg),
    .result(pe_result),
    .valid_out(valid_out)
);

assign result = pe_result;

parameter IDLE=0, SEND=1, WAIT=2, DONE=3;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        index <= 0;
        valid_in <= 0;
    end 
    else begin
        case(state)

        IDLE: begin
            if (start) begin
                index <= 0;
                state <= SEND;
            end
        end

        SEND: begin
            // send ONE valid pulse per cycle
            valid_in <= 1;

            case(index)
                0: begin a_reg <= a0; b_reg <= b0; end
                1: begin a_reg <= a1; b_reg <= b1; end
                2: begin a_reg <= a2; b_reg <= b2; end
                3: begin a_reg <= a3; b_reg <= b3; end
            endcase

            if (index == 3) begin
                state <= WAIT;
            end else begin
                index <= index + 1;
            end
        end

        WAIT: begin
            valid_in<=0;
            // wait for pipeline to finish
            if (valid_out == 0)
                state <= DONE;
        end

        DONE: begin
            state <= IDLE;
        end

        endcase
    end
end

assign done = (state == DONE);

endmodule
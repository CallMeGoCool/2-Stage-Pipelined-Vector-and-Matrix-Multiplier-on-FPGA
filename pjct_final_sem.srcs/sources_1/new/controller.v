module controller(
    input clk,
    input reset,
    input start,
    output reg valid,
    output reg phase,
    output reg done
);

reg [2:0] state;

parameter IDLE = 0,
          LOAD1 = 1,
          LOAD2 = 2,
          WAIT1 = 3,
          DONE  = 4;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        valid <= 0;
        phase <= 0;
        done <= 0;
    end else begin
        case (state)

        IDLE: begin
            done <= 0;
            if (start) begin
                state <= LOAD1;
                valid <= 1;
                phase <= 0;
            end
        end

        LOAD1: begin
            state <= LOAD2;
            phase <= 1;
        end

        LOAD2: begin
            state <= WAIT1;
            valid <= 0; // stop new inputs
        end

        WAIT1: begin
            state <= DONE;
        end

        DONE: begin
            done <= 1;
            state <= IDLE;
        end

        endcase
    end
end

endmodule
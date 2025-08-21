// ============================================================
// Baud Rate Generator (16x oversampling)
// ============================================================
module baud_gen #(
    parameter CLK_FREQ = 50000000, // 50 MHz
    parameter BAUD_RATE = 9600
)(
    input  wire clk,
    input  wire reset,
    output reg  baud_tick
);

    localparam integer DIVISOR = CLK_FREQ / (BAUD_RATE * 16);

    integer count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            baud_tick <= 0;
        end else begin
            if (count == DIVISOR-1) begin
                count <= 0;
                baud_tick <= 1;
            end else begin
                count <= count + 1;
                baud_tick <= 0;
            end
        end
    end
endmodule

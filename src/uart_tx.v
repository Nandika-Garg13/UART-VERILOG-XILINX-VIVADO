// ============================================================
// UART Transmitter
// ============================================================
module uart_tx #(
    parameter DATA_BITS = 8
)(
    input  wire clk,
    input  wire reset,
    input  wire baud_tick,
    input  wire [DATA_BITS-1:0] din,
    input  wire start,
    output reg  tx,
    output reg  busy
);

    reg [3:0] bit_index;
    reg [DATA_BITS-1:0] shift_reg;
    reg [3:0] state;

    localparam IDLE  = 0,
               START = 1,
               DATA  = 2,
               STOP  = 3;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            tx <= 1'b1;
            busy <= 0;
            bit_index <= 0;
        end else if (baud_tick) begin
            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    busy <= 0;
                    if (start) begin
                        shift_reg <= din;
                        state <= START;
                        busy <= 1;
                    end
                end
                START: begin
                    tx <= 1'b0; // start bit
                    state <= DATA;
                    bit_index <= 0;
                end
                DATA: begin
                    tx <= shift_reg[bit_index];
                    if (bit_index == DATA_BITS-1) begin
                        state <= STOP;
                    end else begin
                        bit_index <= bit_index + 1;
                    end
                end
                STOP: begin
                    tx <= 1'b1; // stop bit
                    state <= IDLE;
                    busy <= 0;
                end
            endcase
        end
    end
endmodule

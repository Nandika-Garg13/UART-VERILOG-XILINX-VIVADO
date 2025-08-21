// ============================================================
// UART Receiver
// ============================================================
module uart_rx #(
    parameter DATA_BITS = 8
)(
    input  wire clk,
    input  wire reset,
    input  wire baud_tick,
    input  wire rx,
    output reg  [DATA_BITS-1:0] dout,
    output reg  ready
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
            dout <= 0;
            ready <= 0;
        end else if (baud_tick) begin
            case (state)
                IDLE: begin
                    ready <= 0;
                    if (rx == 0) begin // start bit detected
                        state <= START;
                        bit_index <= 0;
                    end
                end
                START: begin
                    state <= DATA;
                end
                DATA: begin
                    shift_reg[bit_index] <= rx;
                    if (bit_index == DATA_BITS-1) begin
                        state <= STOP;
                    end else begin
                        bit_index <= bit_index + 1;
                    end
                end
                STOP: begin
                    dout <= shift_reg;
                    ready <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule

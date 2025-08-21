// ============================================================
// UART Top Module
// ============================================================
module uart_top(
    input  wire clk,
    input  wire reset,
    input  wire rx,
    input  wire [7:0] tx_data,
    input  wire tx_start,
    output wire tx,
    output wire [7:0] rx_data,
    output wire rx_ready
);

    wire baud_tick;
    wire tx_busy;

    // baud generator
    baud_gen u_baud(
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick)
    );

    // transmitter
    uart_tx u_tx(
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick),
        .din(tx_data),
        .start(tx_start),
        .tx(tx),
        .busy(tx_busy)
    );

    // receiver
    uart_rx u_rx(
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick),
        .rx(rx),
        .dout(rx_data),
        .ready(rx_ready)
    );

endmodule

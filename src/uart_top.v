module uart_top #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD     = 115200
)(
    input  wire clk,
    input  wire reset,
    input  wire tx_start,
    input  wire [7:0] tx_data,
    input  wire rx,
    output wire tx,
    output wire [7:0] rx_data,
    output wire rx_ready,
    output wire tx_busy
);

    wire oversample_tick;
    wire bit_tick;

    // Baud generator
    baud_gen #(.CLK_FREQ(CLK_FREQ), .BAUD(BAUD)) baud_inst (
        .clk(clk),
        .reset(reset),
        .oversample_tick(oversample_tick),
        .bit_tick(bit_tick)
    );

    // Transmitter
    uart_tx #(.CLK_FREQ(CLK_FREQ), .BAUD(BAUD)) tx_inst (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // Receiver
    uart_rx #(.CLK_FREQ(CLK_FREQ), .BAUD(BAUD)) rx_inst (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .rx_data(rx_data),
        .rx_ready(rx_ready)
    );

endmodule

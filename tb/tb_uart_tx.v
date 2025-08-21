`timescale 1ns/1ps
// ------------------------------------------------------------
// Testbench: UART Transmitter
// ------------------------------------------------------------
module tb_uart_tx;

    reg clk = 0;
    always #10 clk = ~clk; // 50 MHz

    reg reset = 1;
    reg [7:0] tx_data;
    reg tx_start;
    wire tx;
    wire [7:0] rx_data;
    wire rx_ready;

    // loopback (connect TX → RX again for visibility)
    wire rx = tx;

    uart_top dut (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx(tx),
        .rx_data(rx_data),
        .rx_ready(rx_ready)
    );

    initial begin
        reset = 1;
        tx_start = 0;
        tx_data  = 8'h00;
        repeat (8) @(posedge clk);
        reset = 0;

        // Send 'A'
        @(posedge clk);
        tx_data  = 8'h41; // ASCII 'A'
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;

        wait(rx_ready);
        $display("TX sent 'A', RX got: %c (0x%02h)", rx_data, rx_data);

        repeat (2000) @(posedge clk);
        $finish;
    end

endmodule

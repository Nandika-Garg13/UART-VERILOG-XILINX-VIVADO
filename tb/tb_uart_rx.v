`timescale 1ns/1ps
// ------------------------------------------------------------
// Testbench: UART Receiver
// Connects TX → RX
// ------------------------------------------------------------
module tb_uart_rx;

    reg clk = 0;
    always #10 clk = ~clk; // 50 MHz

    reg reset = 1;
    reg [7:0] tx_data;
    reg tx_start;
    wire tx;
    wire [7:0] rx_data;
    wire rx_ready;

    // loopback
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
        tx_data = 0;
        repeat (8) @(posedge clk);
        reset = 0;

        // send 0x55
        @(posedge clk);
        tx_data = 8'h55;
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;

        wait(rx_ready);
        $display("RX DATA = %h", rx_data);

        repeat (2000) @(posedge clk);
        $finish;
    end

endmodule

`timescale 1ns/1ps
// ------------------------------------------------------------
// Combined UART Transceiver Testbench
// TX sends → RX receives, then check results
// ------------------------------------------------------------
module tb_uart;

    reg clk = 0;
    always #10 clk = ~clk; // 50 MHz

    reg reset = 1;

    // DUT signals
    reg [7:0] tx_data;
    reg tx_start;
    wire tx;
    wire [7:0] rx_data;
    wire rx_ready;

    // Loopback
    wire rx = tx;

    // DUT instance
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

    // stimulus
    initial begin
        reset = 1;
        tx_start = 0;
        tx_data  = 0;
        repeat (8) @(posedge clk);
        reset = 0;

        // Send HELLO
        send_byte("H");
        send_byte("E");
        send_byte("L");
        send_byte("L");
        send_byte("O");

        repeat (4000) @(posedge clk);
        $finish;
    end

    task send_byte;
        input [7:0] b;
        begin
            @(posedge clk);
            tx_data  = b;
            tx_start = 1;
            @(posedge clk);
            tx_start = 0;

            wait(rx_ready);
            $display("RX: %c (0x%02h)", rx_data, rx_data);
        end
    endtask

endmodule

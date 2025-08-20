module tb_uart;

    reg clk;
    reg reset;
    reg tx_start;
    reg [7:0] tx_data;
    wire tx;
    wire [7:0] rx_data;
    wire rx_ready;
    wire tx_busy;

    // Connect TX back to RX for loopback
    uart_top uut (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .rx(tx),          // loopback
        .tx(tx),
        .rx_data(rx_data),
        .rx_ready(rx_ready),
        .tx_busy(tx_busy)
    );

    // Clock generation
    initial clk = 0;
    always #10 clk = ~clk; // 50 MHz clock

    initial begin
        reset = 1;
        tx_start = 0;
        tx_data = 8'h00;
        #50 reset = 0;

        // Send "A" (0x41)
        #50 tx_data = 8'h41; tx_start = 1;
        #20 tx_start = 0;

        // Wait for RX
        #2000;

        // Send "B" (0x42)
        #50 tx_data = 8'h42; tx_start = 1;
        #20 tx_start = 0;

        #5000 $finish;
    end

endmodule

// ============================================================
// Simple FIFO
// ============================================================
module fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire clk,
    input  wire reset,
    input  wire wr_en,
    input  wire rd_en,
    input  wire [DATA_WIDTH-1:0] din,
    output reg  [DATA_WIDTH-1:0] dout,
    output reg  full,
    output reg  empty
);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    reg [$clog2(DEPTH):0] w_ptr, r_ptr, count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            w_ptr <= 0;
            r_ptr <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            // write
            if (wr_en && !full) begin
                mem[w_ptr] <= din;
                w_ptr <= w_ptr + 1;
                count <= count + 1;
            end
            // read
            if (rd_en && !empty) begin
                dout <= mem[r_ptr];
                r_ptr <= r_ptr + 1;
                count <= count - 1;
            end

            full  <= (count == DEPTH);
            empty <= (count == 0);
        end
    end
endmodule

module fifo #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input  wire clk,
    input  wire reset,
    input  wire wr_en,
    input  wire rd_en,
    input  wire [WIDTH-1:0] din,
    output reg  [WIDTH-1:0] dout,
    output reg  empty,
    output reg  full
);

    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [3:0] wr_ptr, rd_ptr;
    reg [4:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            empty <= 1;
            full <= 0;
        end else begin
            // Write
            if (wr_en && !full) begin
                mem[wr_ptr] <= din;
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;
            end
            // Read
            if (rd_en && !empty) begin
                dout <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;
            end
            empty <= (count == 0);
            full  <= (count == DEPTH);
        end
    end

endmodule

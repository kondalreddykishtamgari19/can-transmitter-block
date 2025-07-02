
`timescale 1ns/1ps

module can_tx_crc_tb;

    // Testbench signals
    reg clk;
    reg rst_n;
    reg start;
    reg [10:0] id;
    reg [7:0] data;
    wire tx;
    wire busy;
    wire [14:0] crc_out;

    // Instantiate the DUT (Device Under Test)
    can_tx_crc uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .id(id),
        .data(data),
        .tx(tx),
        .busy(busy),
        .crc_out(crc_out)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        start = 0;
        id = 11'b10101010101;  // Example CAN ID
        data = 8'hA5;          // Example data

        // Reset pulse
        #20;
        rst_n = 1;

        // Wait and then trigger transmission
        #10;
        start = 1;
        #10;
        start = 0;

        // Let it run for a while
        #500;

        $display("Final CRC: %h", crc_out);
        $finish;
    end

endmodule

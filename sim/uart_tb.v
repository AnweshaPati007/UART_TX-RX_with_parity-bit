`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2026 20:52:02
// Design Name: 
// Module Name: uart_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module uart_tb;

parameter DBIT    = 8;
parameter SB_TICK = 16;

reg clk;
reg reset_n;

// RX interface
wire [DBIT-1:0] r_data;
reg  rd_uart;
wire rx_empty;

// TX interface
reg  [DBIT-1:0] w_data;
reg  wr_uart;
wire tx_full;

// UART pins
wire tx;
wire rx;

reg [10:0] TIMER_FINAL_VALUE;

// Loopback connection
assign rx = tx;

uart DUT (
    .clk(clk),
    .reset_n(reset_n),

    .r_data(r_data),
    .rd_uart(rd_uart),
    .rx_empty(rx_empty),
    .rx(rx),

    .w_data(w_data),
    .wr_uart(wr_uart),
    .tx_full(tx_full),
    .tx(tx),

    .TIMER_FINAL_VALUE(TIMER_FINAL_VALUE)
);

// Clock Generation (100 MHz)

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end


initial begin
    #100000000;   // 100 us
    $display("ERROR: Simulation Timeout");
    $finish;
end

task send_byte(input [7:0] data);
begin
    @(posedge clk);
    w_data  <= data;
    wr_uart <= 1'b1;

    @(posedge clk);
    wr_uart <= 1'b0;

    $display("[%0t] TX FIFO Write = %h", $time, data);
end
endtask

// Check RX Data (FWFT FIFO)

task check_rx(input [7:0] expected);
begin

    // Wait until FIFO contains data
    wait(rx_empty == 0);

    // FWFT FIFO presents data immediately
    @(posedge clk);

    if (r_data == expected)
        $display("[%0t] PASS : Received = %h",
                 $time, r_data);
    else
        $display("[%0t] FAIL : Expected = %h  Received = %h",
                 $time, expected, r_data);

    // Consume FIFO entry
    @(posedge clk);
    rd_uart <= 1'b1;

    @(posedge clk);
    rd_uart <= 1'b0;

end
endtask


initial begin

    reset_n = 0;
    wr_uart = 0;
    rd_uart = 0;
    w_data  = 0;

    // Fast baud for simulation
    TIMER_FINAL_VALUE = 3;

    #100;
    reset_n = 1;

    send_byte(8'h55);
    check_rx(8'h55);

    send_byte(8'hA3);
    check_rx(8'hA3);

    #1000;
 
    $display("Simulation Complete");

    $finish;
end

endmodule
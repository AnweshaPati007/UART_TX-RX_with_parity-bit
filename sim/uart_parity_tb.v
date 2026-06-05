`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2026 15:21:15
// Design Name: 
// Module Name: uart_parity_tb
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


module uart_parity_tb();

parameter DBIT    = 8;
parameter SB_TICK = 16;

reg clk;
reg reset_n;

wire [DBIT-1:0] r_data;
reg  rd_uart;
wire rx_empty;

reg  [DBIT-1:0] w_data;
reg  wr_uart;
wire tx_full;

wire tx;

reg parity_type;
wire parity_error;

reg [10:0] TIMER_FINAL_VALUE;

uart dut (
    .clk(clk),
    .reset_n(reset_n),

    .r_data(r_data),
    .rd_uart(rd_uart),
    .rx_empty(rx_empty),
    .rx(tx),

    .w_data(w_data),
    .wr_uart(wr_uart),
    .tx_full(tx_full),
    .tx(tx),

    .TIMER_FINAL_VALUE(TIMER_FINAL_VALUE),

    .parity_type(parity_type),
    .parity_error(parity_error)
);

// Clock
initial clk = 0;
always #5 clk = ~clk;

task send_byte;
input [7:0] data;
begin
    @(posedge clk);

    w_data  = data;
    wr_uart = 1'b1;

    @(posedge clk);
    wr_uart = 1'b0;

    $display("[%0t] Sent = %h Parity error=%b", $time, data, parity_error);
end
endtask

task read_byte;
begin
    wait(rx_empty == 0);

    @(posedge clk);
    rd_uart = 1'b1;

    @(posedge clk);
    rd_uart = 1'b0;

    $display("[%0t] Received = %h",  $time, r_data);
end
endtask

// Test
initial
begin
    reset_n = 0;

    wr_uart = 0;
    rd_uart = 0;
    w_data  = 0;
    
    TIMER_FINAL_VALUE = 1;

    parity_type = 0;

    repeat(10) @(posedge clk);

    reset_n = 1;

    // EVEN PARITY
    $display("EVEN PARITY TEST");
    parity_type = 0;
    send_byte(8'h55);
    read_byte();
    if(r_data == 8'h55 && parity_error == 0)
        $display("PASS");
    else
        $display("FAIL");

    repeat(50) @(posedge clk);

    // ODD PARITY
    $display("\nODD PARITY TEST");
    parity_type = 1;
    send_byte(8'hA3);
    read_byte();
    if(r_data == 8'hA3 && parity_error == 0)
        $display("PASS");
    else
        $display("FAIL");

    repeat(100) @(posedge clk);

    $finish;
end

endmodule

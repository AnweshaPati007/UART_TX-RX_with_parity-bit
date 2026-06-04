`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2026 16:00:28
// Design Name: 
// Module Name: uart_rx_error_detection
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



module uart_rx_error_detection_tb;

parameter DBIT = 8;
parameter SB_TICK = 16;

reg clk;
reg reset_n;
reg rx;
reg parity_type;

wire s_tick;

wire parity_error;
wire rx_done_tick;
wire [DBIT-1:0] rx_dout;

// Clock
initial clk = 0;
always #5 clk = ~clk;      // 100 MHz


// Baud Tick Generator
timer_input #(.BITS(4)) tick_gen (
    .clk(clk),
    .reset_n(reset_n),
    .enable(1'b1),
    .FINAL_VALUE(4'd0),    // tick every clock
    .done(s_tick)
);

uart_rx #(
    .DBIT(DBIT),
    .SB_TICK(SB_TICK)
) dut (
    .clk(clk),
    .reset_n(reset_n),
    .rx(rx),
    .s_tick(s_tick),
    .parity_type(parity_type),
    .parity_error(parity_error),
    .rx_done_tick(rx_done_tick),
    .rx_dout(rx_dout)
);


task send_bit;
input bit_value;
integer k;
begin
    rx = bit_value;

    for(k=0; k<16; k=k+1)
        @(posedge clk);
end
endtask


task send_frame;
input [7:0] data;
input parity_bit;

integer i;

begin
    send_bit(1'b0);
    for(i=0;i<8;i=i+1)
        send_bit(data[i]);
    send_bit(parity_bit);
    send_bit(1'b1);
end
endtask

always @(posedge clk)
begin
    if(rx_done_tick)
        $display("[%0t] RX_DONE DATA=%h ERR=%b",
                 $time,
                 rx_dout,
                 parity_error);
end

// Test
initial
begin

    reset_n = 0;
    rx = 1'b1;
    parity_type = 1'b0;    // even parity

    repeat(10) @(posedge clk);

    reset_n = 1;

    // TEST 1
    $display("\nTEST 1 : CORRECT PARITY");

    send_frame(8'h55, 1'b0);
    // one frame = 11 bits × 16 ticks
    repeat(250) @(posedge clk);

    if(rx_dout == 8'h55 && parity_error == 0)
        $display("PASS : Correct parity received");
    else
        $display("FAIL : DATA=%h ERR=%b",
                 rx_dout,
                 parity_error);

    // TEST 2
    $display("\nTEST 2 : PARITY ERROR");
    send_frame(8'h55, 1'b1);

    repeat(250) @(posedge clk);

    if(parity_error)
        $display("PASS : Parity error detected");
    else
        $display("FAIL : Parity error NOT detected");

    $display("\nSimulation Complete");

    $finish;

end

endmodule

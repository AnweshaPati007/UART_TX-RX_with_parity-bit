`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Design Name: 
// Module Name: uart_rx
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


module uart_rx
    #(parameter DBIT = 8,    // # data bits
                SB_TICK = 16 // # stop bit ticks
    )
    (
        input clk, reset_n,
        input rx, s_tick,
        input parity_type,
        output parity_error,
        output reg rx_done_tick,
        output [DBIT - 1:0] rx_dout
    );
    
    localparam  idle = 0, start = 1,
                data = 2, parity = 3, stop=4;
                
    reg [2:0] state_reg, state_next;
    reg [3:0] s_reg, s_next;                // keep track of the baud rate ticks (16 total)
    reg [$clog2(DBIT) - 1:0] n_reg, n_next; // keep track of the number of data bits recieved
    reg [DBIT - 1:0] b_reg, b_next;         // stores the recieved data bits
    
    reg rx_parity_reg, rx_parity_next; // latched received parity bit
 
    wire parity_err;
    parity_checker #(.n(DBIT)) parity_chk (
        .data_in        (b_reg),
        .received_parity(rx_parity_reg),
        .parity_type    (parity_type),
        .error          (parity_err)
    );
    
    reg parity_error_reg;
    assign parity_error = parity_error_reg;
    
    // State and other registers
    always @(posedge clk, negedge reset_n)
    begin
        if (~reset_n)
        begin
            state_reg <= idle;
            s_reg <= 0;
            n_reg <= 0;
            b_reg <= 0;
            rx_parity_reg  <= 0;
            parity_error_reg <= 0;
        end
        else
        begin
            state_reg <= state_next;
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;
            rx_parity_reg <= rx_parity_next;
    
            // Latch parity error when frame finishes
            if (state_reg == stop &&
                s_tick &&
                s_reg == (SB_TICK-1))
                parity_error_reg <= parity_err;
    
            // Clear when a new frame starts
            else if (state_reg == idle && ~rx)
                parity_error_reg <= 0;
        end
    end
    
    // Next state logic
    always @(*)
    begin
        state_next = state_reg;
        s_next = s_reg;
        n_next = n_reg;
        b_next = b_reg;
        rx_parity_next  = rx_parity_reg;
        rx_done_tick = 1'b0;
        case (state_reg)
            idle:                
                if (~rx)
                begin
                    s_next = 0;
                    state_next = start;                        
                end                 
            start:                
                if (s_tick)
                    if (s_reg == 7)
                    begin
                        s_next = 0;
                        n_next = 0;
                        state_next = data;
                    end
                    else                        
                        s_next = s_reg + 1;                                                                   
            data:
                if (s_tick)
                    if(s_reg == 15)
                    begin
                        s_next = 0;
                        b_next = {rx, b_reg[DBIT - 1:1]}; // Right shift
                        if (n_reg == (DBIT - 1))
                            state_next = parity;
                        else
                            n_next = n_reg + 1;
                    end
                    else
                        s_next = s_reg + 1;
            parity:
                if (s_tick)
                    if (s_reg == 15) begin
                        s_next= 0;
                        rx_parity_next = rx;               // latch received parity bit
                        state_next= stop;
                    end else
                        s_next = s_reg + 1;
            stop:
                if (s_tick)
                    if(s_reg == (SB_TICK - 1))
                    begin
                        rx_done_tick = 1'b1;
                        state_next = idle;
                    end
                    else
                        s_next = s_reg + 1;
            default:
                state_next = idle;
        endcase
    end
    
    // output logic
    assign rx_dout = b_reg;
endmodule

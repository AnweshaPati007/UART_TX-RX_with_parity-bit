`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2026 12:21:44
// Design Name: 
// Module Name: parity_generator
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


module parity_generator #(parameter n = 8)(
    input [n-1:0] data_in,     // 4-bit input data     
    input parity_type,       // 0 = even parity, 1 = odd parity       
    output reg gen_parity   // generated parity bit     
    );
    always@(*) begin
     if (parity_type == 0)          // Even parity             
            gen_parity = ^data_in;     // XOR of all bits (even parity)         
        else                           // Odd parity            
            gen_parity = ~(^data_in);  // Complement for odd parity        
    end
endmodule



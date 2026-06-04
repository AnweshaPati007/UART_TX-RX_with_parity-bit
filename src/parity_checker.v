`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2026 12:17:04
// Design Name: 
// Module Name: parity_checker
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


module parity_checker #(parameter n = 8)( 
    input [n-1:0] data_in,     // 4-bit input data     
    input received_parity,   // parity bit received (for checking)
    input parity_type,     // 0 = even, 1 = odd     
    output reg error         // error flag 
    );      
    wire expected_parity;
    assign expected_parity = (parity_type == 1'b0) ? (^data_in) : (~(^data_in));
    
    always @(*) begin        
     // Parity checking         
        error = (received_parity != expected_parity);
     end  
     
endmodule

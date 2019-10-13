`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Arsalan Mughal
// 
// Create Date: 04/11/2019 01:20:16 PM
// Design Name: 
// Module Name: Mux4
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


module Mux4# (parameter WIDTH = 4)(
    input [1:0] SEL,
    input[WIDTH - 1:0] ZERO,
    input [WIDTH - 1:0] ONE,
    input[WIDTH - 1:0] TWO,
    input [WIDTH - 1:0] THREE,    
    output logic [WIDTH - 1:0] MUXOUT

    );
    
    always_comb
        begin
            if (SEL == 0)
                begin
                    MUXOUT = ZERO;
                end
            else if (SEL == 1)
                begin
                    MUXOUT = ONE;
                end
            else if (SEL == 2)
                begin
                    MUXOUT = TWO;
                end
            else
                begin
                    MUXOUT = THREE;
                end
        end
endmodule
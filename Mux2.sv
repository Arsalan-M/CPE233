`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Arsalan Mughal
// 
// Create Date: 04/11/2019 01:20:00 PM
// Design Name: 
// Module Name: Mux2
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


module Mux2# (parameter WIDTH = 2)(
    input SEL,
    input[WIDTH - 1:0] ZERO,
    input [WIDTH - 1:0] ONE,
    output logic [WIDTH - 1:0] MUXOUT

    );
    
    always_comb
        begin
            if (SEL == 0)
                begin
                    MUXOUT = ZERO;
                end
            else
                begin
                    MUXOUT = ONE;
                end
        end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2019 12:59:21 PM
// Design Name: 
// Module Name: Interrupt
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


module Interrupt(
	input CLK,
    input I_CLR,
    input I_SET,
    output reg I_OUT
);

always_ff @(posedge CLK)
    begin
        if (I_CLR == 1)
            I_OUT <= 0;
        else if (I_SET == 1)
            I_OUT <= 1;

    end        
endmodule


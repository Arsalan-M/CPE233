`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Arsalan Mughal
// 
// Create Date: 04/11/2019 01:10:57 PM
// Design Name: 
// Module Name: Flag
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Universal Register
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Flag # (parameter WIDTH = 2) (
    input [WIDTH - 1:0] DIN,
    input CLK, LD, SET, CLR,
    output logic [WIDTH - 1:0] DOUT = 0

);

always_ff @ (posedge CLK)
    begin
        if (SET == 1)
            DOUT <= 1;
        else if (CLR == 1)
            DOUT <= 0;
        else if (LD == 1)
            DOUT <= DIN;
    end
endmodule 
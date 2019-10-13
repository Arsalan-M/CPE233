`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2019 05:03:02 PM
// Design Name: 
// Module Name: ProgCounter
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


module ProgCounter (DIN,PC_LD,PC_INC,RST,CLK,PC_COUNT);
    parameter WIDTH = 8; 
    input  CLK, RST, PC_INC, PC_LD; 
    input  [WIDTH-1:0] DIN; 
    output  reg [WIDTH-1:0] PC_COUNT; 

always @(posedge CLK)
begin 
    if (RST == 1)       // sync reset
       PC_COUNT <= 0;
    else if (PC_LD == 1)   // load new value
       PC_COUNT <= DIN; 
    else if (PC_INC == 1)   // count up (increment)
       PC_COUNT <= PC_COUNT + 1; 
end 
   

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2019 09:29:11 AM
// Design Name: 
// Module Name: ScratchRam
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


module ScratchRam(
	input [9:0] DATA_IN,
    input [7:0] SCR_ADDR,
    input  SCR_WE,
    input CLK,
    output [9:0] DATA_OUT
    );

logic [9:0] memory [0:1023];

initial //runs one
    begin
        for(int i = 0; i < 256; i++)
            begin
                memory[i] =0; //initalize all to zero
    end
end

always_ff @ (posedge CLK)
begin

if(SCR_WE == 1)
    begin
        memory[SCR_ADDR] <= DATA_IN;
    end
end

assign DATA_OUT = memory[SCR_ADDR];

endmodule

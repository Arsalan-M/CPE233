`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2019 02:08:37 PM
// Design Name: 
// Module Name: StackPointer
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

module StackPointer(
		input [7:0] D_IN,
		input RST,
		input LD,
		input INCR,
		input DECR,
		input CLK,
		output logic [7:0] D_OUT
);                                                     
                                                                           
always_ff @(posedge CLK)
begin	
	if(RST == 1)
		D_OUT <=0;
	else if(LD == 1)
		D_OUT <= D_IN;
	else if(INCR == 1)
		D_OUT <= D_OUT+1;
	else if(DECR == 1)
		D_OUT <= D_OUT-1;
end

endmodule                                                                 
                


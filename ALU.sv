`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly SLO: CPE 233 - Computer Design and Assembly Language Programming
// Engineer: Arsalan Mughal
// 
// Create Date: 04/29/2019 10:00:25 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [3:0] SEL,
	input [7:0] A,
	input [7:0] B,
	input CIN,
	output logic [7:0] RESULT,
	output logic C,
	output logic Z
    );
    
logic [8:0] D_OUT; 

always_comb
    begin 
    if (SEL == 0)  D_OUT = {1'b0, A}+{1'b0, B}; //ADD
    else if (SEL == 1)  D_OUT = {1'b0, A}+{1'b0, B}+{8'b0000_0000,CIN}; //ADDC
    else if (SEL == 2)  D_OUT = {1'b0, A}-{1'b0, B}; //SUB
    else if (SEL == 3)  D_OUT = {1'b0, A}-{1'b0, B}-{8'b0000_0000,CIN}; //SUBC
    else if (SEL == 4)  D_OUT = {1'b0, A}-{1'b0, B}; //CMP
    else if (SEL == 5)  D_OUT = {1'b0, A}&{1'b0, B}; // AND
    else if (SEL == 6)  D_OUT = {1'b0, A}|{1'b0, B}; // OR
    else if (SEL == 7)  D_OUT = {1'b0, A}^{1'b0, B}; // XOR
    else if (SEL == 8)  D_OUT = {1'b0, A}&{1'b0, B}; // TEST
    else if (SEL == 9)  D_OUT = {A[7], A[6:0], CIN}; //LSL
    else if (SEL == 10)  D_OUT = {A[0],CIN, A[7:1]}; //LSR C = A[0] 
    else if (SEL == 11)  D_OUT = {A[7],A[6:0],A[7]}; //ROL
    else if (SEL == 12)  D_OUT = {A[0],A[0], A[7:1]}; // ROR
    else if (SEL == 13)  D_OUT = {A[0], A[7], A[7:1]}; //ASR
    else if (SEL == 14)  D_OUT = {B}; //MOV
    else if (SEL == 15)  D_OUT = 0; //unused
    else D_OUT = 0; 
    end

   
always_comb
    begin
        C = D_OUT[8];
        RESULT = D_OUT[7:0]; 
        if (D_OUT[7:0] == 8'b0000_0000) Z = 1;
        else Z=0;
    end

endmodule

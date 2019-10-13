`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2019 12:55:13 PM
// Design Name: 
// Module Name: ShadowFlags
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


module ShadowFlags(
	input CLK,
    input FLG_C_SET,
    input FLG_C_LD,
    input C,
    input FLG_C_CLR,
    input FLG_Z_LD,
    input Z,
    input FLG_LD_SEL,
    input FLG_SHAD_LD,
    
    output reg C_FLAG,
    output reg Z_FLAG

);




    logic C_SHAD_OUT, Z_SHAD_OUT;
    logic C_IN, Z_IN;    

Mux2 #1 C_MUX(
        .SEL(FLG_LD_SEL),
        .ZERO(C),
        .ONE(C_SHAD_OUT),
        .MUXOUT(C_IN)
);

//for C flip flop 

always_ff @(posedge CLK)
    begin
        if (FLG_C_CLR ==1)
            C_FLAG <= 0;
        else if (FLG_C_SET == 1)
            C_FLAG <= 1;
        else if (FLG_C_LD == 1)
            C_FLAG <= C_IN;

    end    

//C shadow
always_ff @(posedge CLK)
    begin
        if (FLG_SHAD_LD == 1)
        C_SHAD_OUT <= C_FLAG;

    end    

Mux2 #1 Z_MUX(
        .SEL(FLG_LD_SEL),
        .ZERO(Z),
        .ONE(Z_SHAD_OUT),
        .MUXOUT(Z_IN)
);



//for Z flip flip/
always_ff @(posedge CLK)
    begin
        if (FLG_Z_LD ==1)
            Z_FLAG <= Z_IN;

    end


//Z shadow
always_ff @(posedge CLK)
    begin
        if (FLG_SHAD_LD == 1)
            Z_SHAD_OUT <= Z_FLAG;

    end    




endmodule


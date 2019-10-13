`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2019 04:46:33 PM
// Design Name: 
// Module Name: RatCPU
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


module RatCPU(
	input [7:0] IN_PORT,
	input RESET,
	input INT_CU,
	input CLK,
	output logic [7:0] OUT_PORT,
	output logic [7:0] PORT_ID,
	output logic IO_STRB
	); 

    
    logic [17:0] PROG_IR;
    logic C_FLAG, Z_FLAG;
    logic PC_LD, PC_INC;
    logic [1:0] PC_MUX_SEL;
    logic ALU_OPY_SEL;
    logic [3:0] ALU_SEL;
    logic RF_WR;
    logic [1:0] RF_WR_SEL;
    logic FLG_C_SET;
    logic FLG_C_CLR;
    logic FLG_C_LD;
    logic FLG_Z_LD;
    logic RST;
    logic C,Z;
    logic [9:0] DIN_PC;
    logic [9:0] PC_COUNT;
    logic [7:0] DY_OUT, DX_OUT;
    logic [7:0] B;
    logic [7:0] DIN_RF, RESULT;
    logic  FLG_LD_SEL;
    logic [4:0] ADRX;
    logic [4:0] ADRY;
    logic [9:0] DATA_OUT;
    logic SCR_DATA_SEL;
    logic [9:0] SCR_DATA_IN;
    logic [1:0] SCR_ADDR_SEL;
    logic [7:0] SCR_ADDR_IN;
    logic [7:0] SP_DATA_OUT;
    logic SCR_WE;
    logic SP_LD, SP_INCR, SP_DECR;
    logic I_SET; 
    logic I_CLR;
    logic FLG_SHAD_LD;
    logic I_OUT;

    
    
	ControlUnit CU(
		.OPCODE_HI_5(PROG_IR[17:13]),
		.OPCODE_LOW_2(PROG_IR[1:0]),
		.INT_CU(INT_CU & I_OUT),
		.C_FLAG(C_FLAG),
		.Z_FLAG(Z_FLAG),
		.RESET(RESET),
		.CLK(CLK),		

		.PC_LD(PC_LD),
		.PC_INC(PC_INC),
		.PC_MUX_SEL(PC_MUX_SEL),
		.ALU_OPY_SEL(ALU_OPY_SEL),
		.ALU_SEL(ALU_SEL),
		.RF_WR(RF_WR),
		.RF_WR_SEL(RF_WR_SEL),

		.FLG_C_SET(FLG_C_SET),
		.FLG_C_CLR(FLG_C_CLR),
		.FLG_C_LD(FLG_C_LD),
		.FLG_Z_LD(FLG_Z_LD),
		.RST(RST),
		.IO_STRB(IO_STRB),
		
		.SP_LD(SP_LD),
        .SP_INCR(SP_INCR), 
        .SP_DECR(SP_DECR),
        .SCR_WE(SCR_WE),
        .SCR_ADDR_SEL(SCR_ADDR_SEL), 
        .SCR_DATA_SEL(SCR_DATA_SEL),
        
		.I_SET(I_SET),
        .I_CLR(I_CLR),
        .FLG_SHAD_LD(FLG_SHAD_LD),
        .FLG_LD_SEL(FLG_LD_SEL)
);



	Interrupt INTR_REG(
        .CLK(CLK),
        .I_CLR(I_CLR),
        .I_SET(I_SET),
        .I_OUT(I_OUT)
    );

	Mux4 #10 PC_DIN_INPUT(
		.SEL(PC_MUX_SEL), 
      	.ZERO(PROG_IR[12:3]), 
		.ONE(DATA_OUT),
		.TWO('h3FF), 
		.THREE('h000),
       	.MUXOUT(DIN_PC) 
  
	);

	ProgCounter #10 PC(
		.DIN(DIN_PC),
		.PC_LD(PC_LD),
		.PC_INC(PC_INC),
		.RST(RST),
		.CLK(CLK),
	 	.PC_COUNT(PC_COUNT)
	);

	ProgRom PROM(
		.PROG_CLK(CLK), 
		.PROG_ADDR(PC_COUNT), 
		.PROG_IR(PROG_IR)
	);
	
	
	ShadowFlags flag(
        .CLK(CLK),
        .FLG_C_SET(FLG_C_SET),
        .FLG_C_LD(FLG_C_LD),
        .C(C),
        .FLG_C_CLR(FLG_C_CLR),
        .FLG_Z_LD(FLG_Z_LD),
        .Z(Z),
        .FLG_LD_SEL(FLG_LD_SEL),
        .FLG_SHAD_LD(FLG_SHAD_LD),
        .C_FLAG(C_FLAG),
        .Z_FLAG(Z_FLAG)
       
    );
	
/*	
	Flag CFLAG(
		.CLK(CLK),
		.SET(FLG_C_SET),
		.LD(FLG_C_LD),
		.DIN(C),
		.CLR(FLG_C_CLR),
		.DOUT(C_FLAG)
	);
	
	Flag ZFLAG(
            .CLK(CLK),
            .LD(FLG_Z_LD),
            .DIN(Z),
            .DOUT(Z_FLAG)
        );

*/

	Mux4 #8 RF_DIN_INPUT(
		.SEL(RF_WR_SEL), 
      	.ZERO(RESULT), 
		.ONE(DATA_OUT[7:0]),
		.TWO(0), 
		.THREE(IN_PORT),
       	.MUXOUT(DIN_RF) 
  
	);
	RegisterFile RF(
		.DIN(DIN_RF),
		.ADRX(PROG_IR [12:8]),
		.ADRY(PROG_IR [7:3]),
		.RF_WR(RF_WR),
		.CLK(CLK),
		.DX_OUT(DX_OUT),
		.DY_OUT(DY_OUT)
	);

	Mux2 #8 ALU_B_INPUT(			
		.SEL(ALU_OPY_SEL), 
      	.ZERO(DY_OUT), 
		.ONE(PROG_IR[7:0]), 
		.MUXOUT(B)
	);
	
	
	ALU RAT_ALU(
		.SEL(ALU_SEL),
		.A(DX_OUT),
		.B(B),
		.CIN(C_FLAG),
		.RESULT(RESULT),
		.C(C),
		.Z(Z)
	);

	StackPointer SP(

		 .D_IN(DX_OUT),
		 .RST(RST),
		 .LD(SP_LD),
		 .INCR(SP_INCR),
		 .DECR(SP_DECR),
		 .CLK(CLK),
		 .D_OUT(SP_DATA_OUT)

	 );
	
	Mux2 #10 MUX_SCR_DATA_IN(	
		.SEL(SCR_DATA_SEL), 
        .ZERO({0,0,DX_OUT}), 
		.ONE(PC_COUNT), 
		.MUXOUT(SCR_DATA_IN)
	);

	
	Mux4 #8 MUX_SCR_ADDR_IN(
		.SEL(SCR_ADDR_SEL), 
	    .ZERO(DY_OUT), 
		.ONE(PROG_IR[7:0]), 
		.TWO(SP_DATA_OUT), 
		.THREE(SP_DATA_OUT-1), 
        .MUXOUT(SCR_ADDR_IN) 
  
	);

	ScratchRam SCR(	
	  .DATA_IN(SCR_DATA_IN),
	  .SCR_ADDR(SCR_ADDR_IN),
	  .SCR_WE(SCR_WE),
	  .CLK(CLK),
	  .DATA_OUT(DATA_OUT)
	);	


assign PORT_ID = PROG_IR [7:0];
assign OUT_PORT = DX_OUT;

endmodule
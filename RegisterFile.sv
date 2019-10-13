`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2019 05:28:22 PM
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile(
    input [7:0] DIN,
    input [4:0] ADRX,
    input [4:0] ADRY,
    input RF_WR,
    input CLK,
    output [7:0] DX_OUT,
    output [7:0] DY_OUT
);

logic [7:0] ram [0:31];

// Initialize the memory to be all 0s
initial begin
  int i;
  for (i=0; i<32; i++) begin
    ram[i] = 0;
  end
end

always_ff @ (posedge CLK)
begin

    if (RF_WR == 1)
        ram[ADRX] <= DIN;

end

assign DX_OUT = ram[ADRX];
assign DY_OUT = ram[ADRY];

endmodule

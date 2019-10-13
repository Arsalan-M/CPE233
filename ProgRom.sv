`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2019 09:52:11 AM
// Design Name: 
// Module Name: ProgRom
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
module ProgRom(
    input PROG_CLK,
    input [9:0] PROG_ADDR,
    output logic [17:0] PROG_IR
);
 
    (* rom_style="{distributed | block}" *)  
    
    // force the ROM to be block memory
    
    logic [17:0] rom[0:1023];

// initialize the ROM with the HW3.mem file

initial 
    begin
        $readmemh("snakefinal.mem", rom, 0, 1023);
end 

always_ff @(posedge PROG_CLK) 
    begin
        PROG_IR <= rom[PROG_ADDR];
end
       
endmodule

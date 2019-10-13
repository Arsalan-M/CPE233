`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2019 09:36:17 PM
// Design Name: 
// Module Name: RATWrapper
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


module RAT_WRAPPER(
    
    input CLK,
    
    input BTNL, BTNR, BTNU, BTND,
    input BTNC,
    
    input [7:0] LOW_SWITCHES,
    input [7:0] HIGH_SWITCHES,
    
    input PS2CLK,
    input PS2DATA, 
    
    output [7:0] LEDS,
    output [3:0] ANODES,
    output [7:0] CATHODES,
    
    output [7:0] VGA_RGB,
    output VGA_HS,
    output VGA_VS
    
    
    );
    
    // INPUT PORT IDS ////////////////////////////////////////////////////////
    // Right now, the only possible inputs are the switches
    // In future labs you can add more port IDs, and you'll have
    // to add constants here for the mux below
    localparam LOW_SWITCHES_ID = 8'h20;
    localparam HIGH_SWITCHES_ID = 8'h21;
    
    localparam BUTTONS_ID = 8'hFF;
    
    localparam KEYBOARD_ID = 8'h44;

    localparam VGA_READ_ID = 8'h93;  
    
    localparam RAND_ID = 8'h74;  
    
    assign buttons = {4'b0, BTNL, BTNU, BTNR, BTND};
       
    // OUTPUT PORT IDS ///////////////////////////////////////////////////////
    // In future labs you can add more port IDs
    localparam LEDS_ID      = 8'h40;
    //localparam SEG_ID       = 8'h81;
    localparam SSEG0_ID     = 8'h81;
    localparam SSEG1_ID     = 8'h82;
    localparam VGA_HADDR_ID = 8'h90;
    localparam VGA_LADDR_ID = 8'h91;
    localparam VGA_COLOR_ID = 8'h92;
    
    // Signals for connecting RAT_MCU to RAT_wrapper /////////////////////////
    logic [7:0] s_output_port;
    logic [7:0] s_port_id;
    logic IO_STRB;
    logic s_interrupt;
    logic s_reset;
    logic s_clk_50 = 1'b0;     // 50 MHz clock
    logic [7:0] SEV_SEG;
    logic [7:0] buttons; 
    logic [7:0] s_scancode;
    logic [7:0] s_randnum;
     
    // Signals for connecting VGA Framebuffer Driver
    logic r_vga_we;             // write enable
    logic [12:0] r_vga_wa;      // address of framebuffer to read and write
    logic [7:0] r_vga_wd;       // pixel color data to write to framebuffer
    logic [7:0] r_vga_rd;       // pixel color data read from framebuffer
    
    // Register definitions for output devices ///////////////////////////////
    logic [7:0]   s_input_port;
    logic [7:0]   r_leds = 8'h00;
    //logic [7:0]   r_seg = 8'h00;
    logic [15:0]  r_SSEG = 16'h0000;
    
    // Declare RAT_CPU ///////////////////////////////////////////////////////
    RatCPU CPU (.IN_PORT(s_input_port), 
	           .OUT_PORT(s_output_port),
               .PORT_ID(s_port_id), 
	   	       .IO_STRB(IO_STRB), 
	           .RESET(s_reset),
               .INT_CU(s_interrupt), 
	           .CLK(s_clk_50));
   
    // Declare Seven Segment Display /////////////////////////////////////////
    univ_sseg sevenSeg (.cnt1(r_SSEG), .clk(CLK), .valid(1'b1),
                                   .ssegs(CATHODES), .disp_en(ANODES));

   
    // Declare Keyboard Driver //////////////////////////////////////////////
    KeyboardDriver KEYBD (.CLK(CLK), .PS2DATA(PS2DATA), .PS2CLK(PS2CLK),
                          .INTRPT(s_interrupt), .SCANCODE(s_scancode));
    
    vga_fb_driver VGA(.CLK(s_clk_50), .WA(r_vga_wa), .WD(r_vga_wd),
                                          .WE(r_vga_we), .RD(r_vga_rd), .ROUT(VGA_RGB[7:5]),
                                          .GOUT(VGA_RGB[4:2]), .BOUT(VGA_RGB[1:0]),
                                          .HS(VGA_HS), .VS(VGA_VS));  
   
   
   //RanNum RANDOM(.clk(s_clk_50), .random_num(s_randnum));
   
   RandGen RANDOM(.CLK(s_clk_50), .RST(s_reset), .RANDOM(s_randnum));

   
    // Clock Divider to create 50 MHz Clock //////////////////////////////////
    always_ff @(posedge CLK) begin
        s_clk_50 <= ~s_clk_50;
    end


    // MUX for selecting what input to read //////////////////////////////////
    always_comb begin
        if (s_port_id == LOW_SWITCHES_ID)
            s_input_port = LOW_SWITCHES;
        else if (s_port_id == HIGH_SWITCHES_ID)
            s_input_port = HIGH_SWITCHES;
        else if (s_port_id == BUTTONS_ID)
            s_input_port = buttons;
        else if (s_port_id == KEYBOARD_ID)
            s_input_port = s_scancode;
        else if (s_port_id == VGA_READ_ID)
            s_input_port = r_vga_rd;
        else if (s_port_id == RAND_ID)
            s_input_port = s_randnum;
        else
            s_input_port = 8'h00;
    end

    always_ff @ (posedge CLK) 
    begin
    r_vga_we <= 1'b0;
        if (IO_STRB == 1'b1) 
        begin
            if (s_port_id == LEDS_ID)
                r_leds <= s_output_port;
/*	        else if (s_port_id == SEG_ID)
		        r_seg <= s_output_port;*/
            else if (s_port_id == SSEG0_ID)
                    r_SSEG[7:0] <= s_output_port;
            else if (s_port_id == SSEG1_ID)
                    r_SSEG[15:8] <= s_output_port;		    
            else if (s_port_id == VGA_HADDR_ID)   // Y coordinate
                r_vga_wa[12:7] <= s_output_port[5:0];
            else if (s_port_id == VGA_LADDR_ID)   // X coordinate
                r_vga_wa[6:0] <= s_output_port[6:0];
            else if (s_port_id == VGA_COLOR_ID) 
            begin
                r_vga_wd <= s_output_port;
                r_vga_we <= 1'b1; // write enable to save data to framebuffer
            end
        end
     end
    
   //MODE == 1 (prcoess the valuies as a sev segment in as decimal)



/*univ_sseg Univ( 	
	.cnt1(SEV_SEG),                                                                                    
   	.cnt2(0),                                                                                     
    	.valid(1), 
    	.dp_en(0),                                                                                          
    	.dp_sel(0),                                                                                   
     	.mod_sel(0),                                                                                  
     	.sign(0),                                                                                           
     	.clk(CLK),                                                                                            
    	.ssegs(CATHODES),                                                                               
    	.disp_en(ANODES) 
);*/





    // Debounce //////////////////////////////////////////////////////////////
/*Debounce Debouncer(
		.CLK(s_clk_50),
    	.BTN(BTNL),
    	.DB_BTN(s_interrupt)
    );*/

    // Connect Signals ///////////////////////////////////////////////////////
    assign s_reset = BTNC;
    //assign s_interrupt = 1'b0;  // no interrupt used yet
     
    // Output Assignments ////////////////////////////////////////////////////
    assign LEDS = r_leds;
    //assign SEV_SSEG = r_SSEG;  
endmodule



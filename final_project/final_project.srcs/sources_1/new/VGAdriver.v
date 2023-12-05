`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2023 06:51:52 PM
// Design Name: 
// Module Name: VGAdriver
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


module VGAdriver(
        //input 
        clk,reset,
        //output
        vid_on, hsync, vsync, p_tick,x, y
    );
    
    input clk;
    input reset;
    output vid_on;
    output hsync;
    output vsync;
    output p_tick;
    output [9:0] x;
    output [9:0] y;
    
    //paramters 
    parameter HD = 640;             // horizontal display area width in pixels
    parameter HF = 48;              // horizontal front porch width in pixels
    parameter HB = 16;              // horizontal back porch width in pixels
    parameter HR = 96;              // horizontal retrace width in pixels
    parameter HMAX = HD+HF+HB+HR-1; // max value of horizontal counter = 799
    // Total vertical length of screen = 525 pixels, partitioned into sections
    parameter VD = 480;             // vertical display area length in pixels 
    parameter VF = 10;              // vertical front porch length in pixels  
    parameter VB = 33;              // vertical back porch length in pixels   
    parameter VR = 2;               // vertical retrace length in pixels  
    parameter VMAX = VD+VF+VB+VR-1; // max value of vertical counter = 524   
    
    
    //clock generator for 25mhz
    
    reg [1:0] clk_counter;
    wire w_25MHz;
    
    always @(posedge clk or posedge reset) 
        if(reset)
            clk_counter <= 0;
        else
            clk_counter <= clk_counter + 1;
    assign w_25MHz = (clk_counter == 0) ? 1 : 0;
    
    
    // counter registers to avoid glitches
    reg [9:0] h_count_reg, h_count_next;
    reg [9:0] v_count_reg, v_count_next;
        
    // Output Buffers
    reg v_sync_reg, h_sync_reg;
    wire v_sync_next, h_sync_next;
    
    always @(posedge clk or posedge reset)
            if(reset) begin
                v_count_reg <= 0;
                h_count_reg <= 0;
                v_sync_reg  <= 1'b0;
                h_sync_reg  <= 1'b0;
            end
            else begin
                v_count_reg <= v_count_next;
                h_count_reg <= h_count_next;
                v_sync_reg  <= v_sync_next;
                h_sync_reg  <= h_sync_next;
            end
             
        //Logic for horizontal counter
        always @(posedge w_25MHz or posedge reset)      // pixel tick
            if(reset)
                h_count_next = 0;
            else
                if(h_count_reg == HMAX)                 // end of horizontal scan
                    h_count_next = 0;
                else
                    h_count_next = h_count_reg + 1;         
      
        // Logic for vertical counter
        always @(posedge w_25MHz or posedge reset)
            if(reset)
                v_count_next = 0;
            else
                if(h_count_reg == HMAX)                 // end of horizontal scan
                    if((v_count_reg == VMAX))           // end of vertical scan
                        v_count_next = 0;
                    else
                        v_count_next = v_count_reg + 1;
            
        // h_sync_next asserted within the horizontal retrace area
        assign h_sync_next = (h_count_reg >= (HD+HB) && h_count_reg <= (HD+HB+HR-1));
        
        // v_sync_next asserted within the vertical retrace area
        assign v_sync_next = (v_count_reg >= (VD+VB) && v_count_reg <= (VD+VB+VR-1));
        
        // Video ON/OFF - only ON while pixel counts are within the display area
        assign video_on = (h_count_reg < HD) && (v_count_reg < VD); // 0-639 and 0-479 respectively
                
        // Outputs
        assign hsync  = h_sync_reg;
        assign vsync  = v_sync_reg;
        assign x      = h_count_reg;
        assign y      = v_count_reg;
        assign p_tick = w_25MHz;
    
endmodule

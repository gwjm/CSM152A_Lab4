`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2023 07:27:18 PM
// Design Name: 
// Module Name: top
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


module top(
        // non pmod inputs
        clk, reset, up, down, hsync, vsync, rgb, pmod_switch, pause_switch,
        //pmod inputs
         MISO, SW, SS, MOSI, SCLK, LED, an, seg
    );
    
     input clk;
     input reset;
     input up;
     input down;
     input pmod_switch;
     input pause_switch;
     output hsync;
     output vsync;
     output [11:0] rgb;
     
     input MISO;					// Master In Slave Out, Pin 3, Port JA
     input [2:0] SW;            // Switches 2, 1, and 0
     output SS;                    // Slave Select, Pin 1, Port JA
     output MOSI;                // Master Out Slave In, Pin 2, Port JA
     output SCLK;                // Serial Clock, Pin 4, Port JA
     output [2:0] LED;			// LEDs 2, 1, and 0
     output [3:0] an;			// Anodes for Seven Segment Display
     output [6:0] seg;            // Cathodes for Seven Segment Display
     
     wire w_reset, w_up, w_down, w_vid_on, w_p_tick;
     wire [9:0] w_x, w_y;
     reg [11:0] rgb_reg;
     wire [11:0] rgb_next;
     
     wire SS;						// Active low
     wire MOSI;                    // Data transfer from master to slave
     wire SCLK;                    // Serial clock that controls communication
     reg [2:0] LED;                // Status of PmodJSTK buttons displayed on LEDs   
     wire [3:0] an;                // Anodes for Seven Segment Display
     wire [6:0] seg;            // Cathodes for Seven Segment Display

     // Holds data to be sent to PmodJSTK
     wire [7:0] sndData;

     // Signal to send/receive data to/from PmodJSTK
     wire sndRec;

     // Data read from PmodJSTK
     wire [39:0] jstkData;

     // Signal carrying output data that user selected
     wire [9:0] posData;
     
     wire score;
     
     wire [3:0] dig0, dig1, dig2, dig3;
     reg d_inc, d_clr;


     
     PmodJSTK PmodJSTK_Int(
             .CLK(clk),
             .RST(reset),
             .sndRec(sndRec),
             .DIN(sndData),
             .MISO(MISO),
             .SS(SS),
             .SCLK(SCLK),
             .MOSI(MOSI),
             .DOUT(jstkData)
                 );
      clk5Hz genSndRec(
             .CLK(clk),
             .RST(reset),
             .CLKOUT(sndRec)
     );
     
     
     
          
      assign posData = {jstkData[25:24], jstkData[39:32]};
      
      // Data to be sent to PmodJSTK, lower two bits will turn on leds on PmodJSTK
      assign sndData = {8'b100000, {SW[1], SW[2]}};
 
      // Assign PmodJSTK button status to LED[2:0]
      always @(sndRec or reset or jstkData) begin
              if(reset == 1'b1) begin
                      LED <= 3'b000;
              end
              else begin
                      LED <= {jstkData[1], {jstkData[2], jstkData[0]}};
              end
      end
      
     
     VGAdriver vga(.clk(clk), .reset(w_reset), .video_on(w_vid_on), .hsync(hsync), .vsync(vsync), .p_tick(w_p_tick), .x(w_x), .y(w_y));
     pixelGenerator pg(.clk(clk), .reset(w_reset), .up(w_up), .down(w_down),.video_on(w_vid_on), .x(w_x), .y(w_y), .switch(pmod_switch), .posdata(posData), .score(score), .pause(pause_switch), .rgb(rgb_next));
     debouncer btReset(.clk(clk), .btn_in(reset), .btn_out(w_reset));
     debouncer btnU(.clk(clk), .btn_in(up), .btn_out(w_up));
     debouncer btnD(.clk(clk), .btn_in(down), .btn_out(w_down));
     scorecounter gs(.clk(clk), .reset(reset), .d_inc(d_inc), .d_clr(d_clr), .dig0(dig0), .dig1(dig1), .dig2(dig2), .dig3(dig3));
     sevenSeg display(
                              .CLK(clk),
                              .RST(reset),
                              .DIN1(dig0),
                              .DIN2(dig1),
                              .DIN3(dig2),
                              .DIN4(dig3),
                              .AN(an),
                              .SEG(seg)
                      );
      always @(*) begin
            d_clr = 1'b0; 
            d_inc = 1'b0;
            if(score)
                d_inc = 1'b1;
      end                
     
     
     // rgb buffer
     always @(posedge clk)
         if(w_p_tick)
             rgb_reg <= rgb_next;
             
     assign rgb = rgb_reg;
endmodule

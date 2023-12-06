`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2023 01:29:55 AM
// Design Name: 
// Module Name: debouncer
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


module debouncer(
   clk,      // 100MHz
   btn_in,
   btn_out
   );
   
   input clk;      // 100MHz
   input btn_in;
   output btn_out;
   
   reg r1, r2, r3;
   
   always @(posedge clk) begin
       r1 <= btn_in;
       r2 <= r1;
       r3 <= r2;
   end
   
   assign btn_out = r3;
   
endmodule

    
    
    
    
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2023 11:20:16 PM
// Design Name: 
// Module Name: scorecounter
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


module scorecounter(
   input clk,
   input reset,
   input d_inc, d_clr,
   output [3:0] dig0, dig1, dig2, dig3
   );
   
   // signal declaration
   reg [3:0] r_dig0, r_dig1, r_dig2, r_dig3;
   
   // register control
   always @(posedge d_inc or posedge reset)
       if(reset) begin
           r_dig3 <= 0;
           r_dig2 <= 0;
           r_dig1 <= 0;
           r_dig0 <= 0;
       end else begin
            if(d_inc) begin
                if (r_dig0 == 9 && r_dig1 == 9) begin
                            // reset seconds
                            r_dig0 <= 0;
                            r_dig1 <= 0;
                            
                            // increment minutes
                            if (r_dig2 == 9 && r_dig3 == 9) begin
                                // reset minutes
                                r_dig2 <= 4'b0;
                                r_dig3 <= 4'b0;
                            end
                            else if (r_dig2 == 9) begin
                                // overflow min
                                r_dig2 <= 4'b0;
                                r_dig3 <= r_dig3 + 4'b1;
                            end
                            else begin
                                r_dig2 <= r_dig2 + 4'b1;
                            end
                        end
                        else if (r_dig0 == 9) begin
                            // seconds overflow
                            r_dig0 <= 4'b0;
                            r_dig1 <= r_dig1 + 4'b1;
                        end
                        else begin
                            r_dig0 <= r_dig0 + 4'b1;
                        end
                    end 
            end

   assign dig0 = r_dig0;
   assign dig1 = r_dig1;
   assign dig2 = r_dig2;
   assign dig3 = r_dig3;
   
endmodule
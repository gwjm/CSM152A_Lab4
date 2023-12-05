`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2023 09:31:45 PM
// Design Name: 
// Module Name: clk66kHZ
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


module clk66kHZ(
        CLK,											// 100MHz onbaord clock
    RST,											// Reset
    CLKOUT										// New clock output
    );

// ===========================================================================
// 										Port Declarations
// ===========================================================================
	input CLK;
	input RST;
	output CLKOUT;

// ===========================================================================
// 							  Parameters, Regsiters, and Wires
// ===========================================================================
	// Output register
	reg CLKOUT = 1'b1;

	// Value to toggle output clock at
	parameter cntEndVal = 10'b1011101110;
	// Current count
	reg [9:0] clkCount = 10'b0000000000;

// ===========================================================================
// 										Implementation
// ===========================================================================

	//----------------------------------------------
	//						Serial Clock
	//			66.67kHz Clock Divider, period 15us
	//----------------------------------------------
	always @(posedge CLK) begin

			// Reset clock
			if(RST == 1'b1) begin
					CLKOUT <= 1'b0;
					clkCount <= 10'b0000000000;
			end
			// Count/toggle normally
			else begin

					if(clkCount == cntEndVal) begin
							CLKOUT <= ~CLKOUT;
							clkCount <= 10'b0000000000;
					end
					else begin
							clkCount <= clkCount + 1'b1;
					end

			end

	end

endmodule
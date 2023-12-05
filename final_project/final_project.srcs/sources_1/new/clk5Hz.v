`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2023 09:30:52 PM
// Design Name: 
// Module Name: clk5Hz
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


module clk5Hz(
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
	reg CLKOUT;
	
	// Value to toggle output clock at
	parameter cntEndVal = 24'h989680;
	// Current count
	reg [23:0] clkCount = 24'h000000;
	

// ===========================================================================
// 										Implementation
// ===========================================================================

	//-------------------------------------------------
	//	5Hz Clock Divider Generates Send/Receive signal
	//-------------------------------------------------
	always @(posedge CLK) begin

			// Reset clock
			if(RST == 1'b1) begin
					CLKOUT <= 1'b0;
					clkCount <= 24'h000000;
			end
			else begin

					if(clkCount == cntEndVal) begin
							CLKOUT <= ~CLKOUT;
							clkCount <= 24'h000000;
					end
					else begin
							clkCount <= clkCount + 1'b1;
					end

			end

	end

endmodule
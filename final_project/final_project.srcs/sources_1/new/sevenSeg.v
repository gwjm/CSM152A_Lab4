`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2023 07:25:35 PM
// Design Name: 
// Module Name: sevenSeg
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


module sevenSeg(
        
		CLK,
		RST,
		DIN1,
		DIN2,
		DIN3,
        DIN4,
		AN,
		SEG
   );


	// ===========================================================================
	// 										Port Declarations
	// ===========================================================================
			input CLK;						// 100Mhz clock
			input RST;						// Reset
			input [3:0] DIN1;				// Input data to display
			input [3:0] DIN2;				// Input data to display
			input [3:0] DIN3;				// Input data to display
			input [3:0] DIN4;				// Input data to display
			output [3:0] AN;				// Anodes for seven segment display
			output [6:0] SEG;				// Cathodes for seven segment display
			
	// ===========================================================================
	// 							  Parameters, Regsiters, and Wires
	// ===========================================================================

			// Outputs to Seven Segment Display
			reg [3:0] AN = 4'hF;
			reg [6:0] SEG = 7'b0000000;

			// 1 kHz Clock Divider
			parameter cntEndVal = 16'hC350;
			reg [15:0] clkCount = 16'h0000;
			reg DCLK;

			// 2 Bit Counter
			reg [1:0] CNT = 2'b00;

			// Binary to BCD
			wire [15:0] bcdData1;
			wire [15:0] bcdData2;


			// Output Data Mux
			reg [3:0] muxData;

	// ===========================================================================
	// 										Implementation
	// ===========================================================================
			//------------------------------
			//			Output Data Mux
			// Select data to display on SSD
			//------------------------------
			always @(CNT[1], CNT[0],RST) begin
					if(RST == 1'b1) begin
							muxData <= 4'b0000;
					end
					else begin
							case (CNT)
									2'b00 : muxData <= DIN1;
									2'b01 : muxData <= DIN2;
									2'b10 : muxData <= DIN3;
									2'b11 : muxData <= DIN4;
							endcase
					end
			end
			
			
			
			//------------------------------
			//		   Segment Decoder
			// Determines cathode pattern
			//   to display digit on SSD
			//------------------------------
			always @(posedge DCLK) begin
					if(RST == 1'b1) begin
							SEG <= 7'b1000000;
					end
					else begin
							case (muxData)

									4'h0 : SEG <= 7'b1000000;  // 0
									4'h1 : SEG <= 7'b1111001;  // 1
									4'h2 : SEG <= 7'b0100100;  // 2
									4'h3 : SEG <= 7'b0110000;  // 3
									4'h4 : SEG <= 7'b0011001;  // 4
									4'h5 : SEG <= 7'b0010010;  // 5
									4'h6 : SEG <= 7'b0000010;  // 6
									4'h7 : SEG <= 7'b1111000;  // 7
									4'h8 : SEG <= 7'b0000000;  // 8
									4'h9 : SEG <= 7'b0010000;  // 9
									default : SEG <= 7'b1111111;
									
							endcase
					end
			end



			//---------------------------------
			//	  		  Anode Decoder
			//    Determines digit digit to
			//   illuminate for clock period
			//---------------------------------
			always @(posedge DCLK) begin
					if(RST == 1'b1) begin
							AN <= 4'b0000;
					end
					else begin
							case (CNT)

									4'h0 : AN <= 4'b1110;  // 0
									4'h1 : AN <= 4'b1101;  // 1
									4'h2 : AN <= 4'b1011;  // 2
									4'h3 : AN <= 4'b0111;  // 3
									default : AN <= 4'b1111;
									
							endcase
					end
			end	
			

			//------------------------------
			//			2 Bit Counter
			//	 Used to select which diigt
			//	  is being illuminated, and
			//	selects data to be displayed
			//------------------------------
			always @(posedge DCLK) begin
					CNT <= CNT + 1'b1;
			end
			
			//------------------------------
			//			1khz Clock Divider
			//  Timing for refreshing the
			//  			 SSD, etc.
			//------------------------------
			always @(posedge CLK) begin

							if(clkCount == cntEndVal) begin
									DCLK <= 1'b1;
									clkCount <= 16'h0000;
							end
							else begin
									DCLK <= 1'b0;
									clkCount <= clkCount + 1'b1;
							end
			end
	

endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2023 07:27:59 PM
// Design Name: 
// Module Name: bin2bcd
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


module bin2bcd(
            CLK,
			RST,
			START,
			BIN,
			BCDOUT
	);


	// ===========================================================================
	// 										Port Declarations
	// ===========================================================================
			input CLK;						// 100Mhz CLK
			input RST;						// Reset
			input START;					// Signal to initialize conversion
			input [9:0] BIN;				// Binary value to be converted
			output [15:0] BCDOUT;		// 4 digit binary coded decimal output


	// ===========================================================================
	// 							  Parameters, Regsiters, and Wires
	// ===========================================================================
			reg [15:0] BCDOUT = 16'h0000;		// Output BCD values, contains 4 digits
			
			reg [4:0] shiftCount = 5'b00000;	// Stores number of shifts executed
			reg [27:0] tmpSR;						// Temporary shift regsiter

			reg [2:0] STATE = Idle;				// Present state
			
			// FSM States
			parameter [2:0] Idle = 3'b000,
								 Init = 3'b001,
								 Shift = 3'b011,
								 Check = 3'b010,
								 Done = 3'b110;


	// ===========================================================================
	// 										Implementation
	// ===========================================================================


			//------------------------------
			//		  Binary to BCD FSM
			//------------------------------
			always @(posedge CLK) begin
					if(RST == 1'b1) begin
							// Reset/clear values
							BCDOUT <= 16'h0000;
							tmpSR <= 28'h0000000;
							STATE <= Idle;
					end
					else begin

							case (STATE)
							
									// Idle State
									Idle : begin
											BCDOUT <= BCDOUT;								 	// Output does not change
											tmpSR <= 28'h0000000;							// Temp shift reg empty
											
											if(START == 1'b1) begin
													STATE <= Init;
											end
											else begin
													STATE <= Idle;
											end
									end

									// Init State
									Init : begin
											BCDOUT <= BCDOUT;									// Output does not change
											tmpSR <= {18'b000000000000000000, BIN};	// Copy input to lower 10 bits

											STATE <= Shift;
									end

									// Shift State
									Shift : begin
											BCDOUT <= BCDOUT;							// Output does not change
											tmpSR <= {tmpSR[26:0], 1'b0};			// Shift left 1 bit

											shiftCount <= shiftCount + 1'b1;		// Count the shift
											
											STATE <= Check;							// Check digits

									end

									// Check State
									Check : begin
											BCDOUT <= BCDOUT;							// Output does not change

											// Not done converting
											if(shiftCount != 5'd12) begin

													// Add 3 to thousands place
													if(tmpSR[27:24] >= 3'd5) begin
															tmpSR[27:24] <= tmpSR[27:24] + 2'd3;
													end

													// Add 3 to hundreds place
													if(tmpSR[23:20] >= 3'd5) begin
															tmpSR[23:20] <= tmpSR[23:20] + 2'd3;
													end
													
													// Add 3 to tens place
													if(tmpSR[19:16] >= 3'd5) begin
															tmpSR[19:16] <= tmpSR[19:16] + 2'd3;
													end
													
													// Add 3 to ones place
													if(tmpSR[15:12] >= 3'd5) begin
															tmpSR[15:12] <= tmpSR[15:12] + 2'd3;
													end

													STATE <= Shift;	// Shift again

											end
											// Done converting
											else begin
													STATE <= Done;
											end
											
									end
									
									// Done State
									Done : begin
									
											BCDOUT <= tmpSR[27:12];	// Assign output the new BCD values
											tmpSR <= 28'h0000000;	// Clear temp shift register
											shiftCount <= 5'b00000; // Clear shift count

											STATE <= Idle;

									end
							endcase
					end
			end

endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2023 08:36:04 PM
// Design Name: 
// Module Name: PmodJSTK
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


module PmodJSTK(
        CLK,
			RST,
			sndRec,
			DIN,
			MISO,
			SS,
			SCLK,
			MOSI,
			DOUT
    );

// ===========================================================================
// 										Port Declarations
// ===========================================================================
			input CLK;						// 100MHz onboard clock
			input RST;						// Reset
			input sndRec;					// Send receive, initializes data read/write
			input [7:0] DIN;				// Data that is to be sent to the slave
			input MISO;						// Master in slave out
			output SS;						// Slave select, active low
			output SCLK;					// Serial clock
			output MOSI;					// Master out slave in
			output [39:0] DOUT;			// All data read from the slave

// ===========================================================================
// 							  Parameters, Regsiters, and Wires
// ===========================================================================

			// Output wires and registers
			wire SS;
			wire SCLK;
			wire MOSI;
			wire [39:0] DOUT;

			wire getByte;									// Initiates a data byte transfer in SPI_Int
			wire [7:0] sndData;							// Data to be sent to Slave
			wire [7:0] RxData;							// Output data from SPI_Int
			wire BUSY;										// Handshake from SPI_Int to SPI_Ctrl
			

			// 66.67kHz Clock Divider, period 15us
			wire iSCLK;										// Internal serial clock,
																// not directly output to slave,
																// controls state machine, etc.

// ===========================================================================
// 										Implementation
// ===========================================================================

			//-----------------------------------------------
			//  	  				SPI Controller
			//-----------------------------------------------
			spiCtrl SPI_Ctrl(
					.CLK(iSCLK),
					.RST(RST),
					.sndRec(sndRec),
					.BUSY(BUSY),
					.DIN(DIN),
					.RxData(RxData),
					.SS(SS),
					.getByte(getByte),
					.sndData(sndData),
					.DOUT(DOUT)
			);

			//-----------------------------------------------
			//  	  				  SPI Mode 0
			//-----------------------------------------------
			SPImode0 SPI_Int(
					.CLK(iSCLK),
					.RST(RST),
					.sndRec(getByte),
					.DIN(sndData),
					.MISO(MISO),
					.MOSI(MOSI),
					.SCLK(SCLK),
					.BUSY(BUSY),
					.DOUT(RxData)
			);

			//-----------------------------------------------
			//  	  				SPI Controller
			//-----------------------------------------------
			clk66kHZ SerialClock(
					.CLK(CLK),
					.RST(RST),
					.CLKOUT(iSCLK)
			);

endmodule

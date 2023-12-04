`timescale 1ns/1ps


module SPIControl (
    input clk,      // Clock input
    input rst,      // Reset input
    output reg sndRec,  // Output signal indicating the start of SPI transaction
    output reg busy,     // Output signal indicating busy state
    input [7:0] dSend,   // 8-bit data input
    output reg [7:0] RxData,  // 8-bit data output
    output reg ss,       // Slave select output
    output reg getByte,  // Output signal to initiate data read
    input [7:0] sndData,  // 8-bit data output
    output reg dread     // Output signal indicating data is ready to be read
);

// Internal state machine states
parameter IDLE = 2'b00;
parameter TRANSFER = 2'b01;
parameter WAIT_FOR_READ = 2'b10;

reg [1:0] state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset logic
        state <= IDLE;
        busy <= 0;
        sndRec <= 0;
        RxData <= 8'b0;
        ss <= 1; // Assuming active-low SS
        getByte <= 0;
        dread <= 0;
    end else begin
        // State machine logic
        case (state)
            IDLE:
                if (sndRec) begin
                    state <= TRANSFER;
                    busy <= 1;
                    ss <= 0; // Enable slave select
                end
            TRANSFER:
                // Your SPI communication logic goes here
                // For example, shift in/out data based on the joystick protocol
                // Update RxData accordingly
                if (rising_edge(clk)) begin
                    // Shift out data on MOSI
                    sndRec <= 0;
                    txData <= {txData[6:0], dSend[7]};
                end

                // Sample data on MISO
                RxData <= {RxData[6:0], sndData[7]};
                
                if (falling_edge(clk)) begin
                    // Shift in data from MISO
                    sndData <= {sndData[6:0], RxData[7]};
                end

                // Transition to the next state when the transfer is complete
                if (ss && (txData == 8'b0)) begin
                    state <= WAIT_FOR_READ;
                    getByte <= 1;
                end
            WAIT_FOR_READ:
                if (getByte) begin
                    // Your logic to read data from the joystick
                    // Update RxData accordingly
                    dread <= 1;
                    state <= IDLE;
                    busy <= 0;
                    ss <= 1; // Disable slave select
                end
        endcase
    end
end

endmodule
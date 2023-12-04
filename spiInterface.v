`timescale 1ns/1ps

module SPIInterface (
    input wire clk,         // Clock input
    input wire rst,         // Reset input
    input wire [7:0] mosi,  // Master Out, Slave In
    output reg [7:0] miso,  // Master In, Slave Out
    output reg sclk,        // Serial Clock
    output reg nss,         // Active-Low Slave Select
    output reg ready        // Ready signal indicating when the interface is ready for data transfer
);

// Internal state machine states
parameter IDLE = 2'b00;
parameter TRANSFER = 2'b01;

reg [1:0] state;

// Internal shift register for data transmission
reg [7:0] shiftReg;
reg [3:0] bitCounter;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset logic
        state <= IDLE;
        shiftReg <= 8'b0;
        bitCounter <= 4'b0;
        miso <= 8'b0;
        sclk <= 0;
        nss <= 1; // Initialize Slave Select to high
        ready <= 1; // Initialize as ready
    end else begin
        // State machine logic
        case (state)
            IDLE:
                if (!nss) begin
                    // Slave Select is asserted, start data transfer
                    state <= TRANSFER;
                    bitCounter <= 4'b0;
                    shiftReg <= mosi; // Load MOSI data into shift register
                    sclk <= 0; // Initialize clock
                end
            TRANSFER:
                // Shift data on rising edge of clock
                if (rising_edge(clk)) begin
                    sclk <= ~sclk;
                    if (sclk) begin
                        // Shift out data on MISO line
                        miso <= shiftReg[7];
                        shiftReg <= {shiftReg[6:0], mosi};
                        bitCounter <= bitCounter + 1;
                        if (bitCounter == 3) begin
                            // Data transfer complete
                            state <= IDLE;
                            ready <= 1; // Ready for the next transfer
                        end
                    end
                end
        endcase
    end
end

endmodule
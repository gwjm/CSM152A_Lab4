`timescale 1ns/1ps

module clock_dividers (
    clk,
    rst,
    clk_5hz,
    clk_66Khz
);
    // Argument Declarations
    input clk; 
    input rst;
    output reg clk_5hz = 1'b1;
    output reg clk_66Khz = 1'b1;

    // Clock Dividers
    parameter CNT_5HZ = 28'd1500000;
    parameter CNT_66KHZ = 28'd20000000;
    reg [27:0] cnt_5hz = 28'd0;
    reg [27:0] cnt_66khz = 28'd0;

    // Clock Divider Logic
    always @(posedge clk) begin
        if(rst == 1'b1) begin 
            clk_5hz <= 1'b1;
            clk_66Khz <= 1'b1;
            cnt_5hz <= 28'd0;
            cnt_66khz <= 28'd0;
        end else begin
            cnt_5hz <= cnt_5hz + 1'b1;
            cnt_66khz <= cnt_66khz + 1'b1;
            if(cnt_5hz == CNT_5HZ) begin
                clk_5hz <= ~clk_5hz;
                cnt_5hz <= 28'd0;
            end
            if(cnt_66khz == CNT_66KHZ) begin
                clk_66Khz <= ~clk_66Khz;
                cnt_66khz <= 28'd0;
            end
        end

    end
endmodule 
`timescale 1ns/1ps

module PMODJSTK(
    clk, 
    rst, 
    sndrcv,
    dsend, 
    miso, 
    ss,
    sclk,
    mosi,
    dread
);
    input clk; 
    input rst;
    input sndrcv; 
    input [7:0] dsend;
    input [7:0] miso;
    output wire ss;
    output wire sclk;
    input wire mosi;
    output wire[39:0] dread;

    wire getbyte; 
    wire [7:0] sndData;
    wire [7:0] RxData;
    wire busy; 
    wire isclk; 

    clock_dividers clock_dividers(
        .clk(clk),
        .rst(rst),
        .clk_5hz(),
        .clk_66Khz(isclk)
    );

    SPIControl spi_controller(
        .clk(isclk),
        .rst(rst),
        .sndRec(sndrcv),
        .busy(busy),
        .dSend(dsend),
        .RxData(RxData),
        .ss(ss),
        .getByte(getbyte),
        .sndData(sndData),
        .dread(dread)
    );

    SPIInterface spi_interface(
        .clk(isclk),
        .rst(rst),
        .mosi(mosi),
        .miso(miso),
        .sclk(sclk),
        .nss(ss),
        .ready(getbyte)
    );
endmodule 
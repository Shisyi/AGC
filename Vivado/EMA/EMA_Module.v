`timescale 1ns / 1ps
//(* use_dsp = "yes" *)
module EMA_Module
#(   
    parameter BWIDTH = 18,
    parameter AWIDTH = 30,
    parameter DWIDTH = 27,
    parameter CWIDTH = 48,
    parameter INMODEWIDTH = 5,
    parameter MULT = 45,
    parameter OUTWIDTH = 48  //parameter
) (
    input  wire clk,
    input  wire valid,
    input  wire [BWIDTH-1:0     ] b_in,
    input  wire [AWIDTH-1:0     ] a_in,
    input  wire [DWIDTH-1:0     ] d_in,
    input  wire [CWIDTH-1:0     ] c_in,
    output wire [OUTWIDTH-1:0   ] out
);
    reg  signed [INMODEWIDTH-1:0]
            INMODE;

    reg  signed [AWIDTH-1:0]
            a1;

    reg  signed [DWIDTH-1:0]
            d;

    reg  signed [BWIDTH-1:0]
            b1,b2;

    reg  signed [DWIDTH-1:0]
            pread; 

    reg  signed [MULT-1:0]
            mult,
            reg_mult,
            c        = "0x00",
            accum    = "0x00";

always @(posedge clk) begin
   a1 <= reg_mult;
   d  <= d_in;
   b1 <= b_in;
   //INMODE <= "11101";
end

always @(posedge clk) begin
    pread <= d - a1;
    b2    <= b1;
end


always @(posedge clk) begin
    mult  <= b2 * pread;
end

always @(posedge clk) begin
    reg_mult <= mult;
end

always @(posedge clk) begin
    
    accum    <= reg_mult + c;
    c <= accum;
end

assign out = reg_mult;

endmodule

`timescale 1ns / 1ps
//(* use_dsp = "yes" *)
module EMA_Module
#(   
    parameter BWIDTH = 18,
    parameter AWIDTH = 30,
    parameter DWIDTH = 27,
    parameter CWIDTH = 48,
    parameter MULT = 45,
    parameter OUTWIDTH = 48  //parameter
) (
    input  wire clk,
    input  wire [BWIDTH-1:0     ] b_in,
    input  wire [DWIDTH-1:0     ] d_in,
    output wire [OUTWIDTH-1:0   ] out
);

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
            reg_mult;

    reg  signed [OUTWIDTH-1:0]        
            c        = "0x00",
            accum    = "0x00";
   //INMODE <= "11101";
always @(posedge clk) begin

    d  <= d_in;
    b1 <= b_in;
  //  a1 <= accum; 
 
    pread <= d - accum;
    b2    <= b1;
    mult  <= b2 * pread;

    accum <= mult + c;

    c     <= accum;

end

assign out = accum;

endmodule

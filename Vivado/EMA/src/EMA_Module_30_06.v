`timescale 1ns / 1ps
//(* use_dsp = "yes" *)
module EMA_Module
#(   
    parameter BWIDTH = 18,
//    parameter AWIDTH = 30,
    parameter DWIDTH = 27,
//    parameter MULT = 45,
    parameter OUTWIDTH = 48  //parameter
) (
    input  wire clk,
    input  wire [BWIDTH-1:0     ] Filter_Coefficient,
    input  wire [DWIDTH-1:0     ] Data,
    input  wire                   Valid,
    output wire                   Valid_out_ema,
    output wire [OUTWIDTH-1:0   ] Filter_Out
);

//  reg  signed [AWIDTH-1:0]
//            a1;

    reg  signed [DWIDTH-1:0]
           d;

    reg  signed [BWIDTH-1:0]
            b2;

    reg  signed [DWIDTH-1:0]
            pread; 

//    reg  signed [MULT-1:0]
//            mult,
//            reg_mult;

    reg  signed [OUTWIDTH-1:0]        
            c     ,
            accum ;
    reg 
        Valid_1,Valid_2;
   //INMODE <= "11101";
always @(posedge clk) begin


  //  a1 <= accum;
    d       <= Data ;
    pread   <= d - accum[OUTWIDTH-1:18];
    Valid_1 <= Valid;
   // b1    <= Filter_Coefficient;
    b2    <= Filter_Coefficient;
   // mult  <= b2 * pread;

    if (Valid_2) begin
        c     <= accum;
    end

    if (Valid_1) begin
        accum   <= b2 * pread + c;
        Valid_2 <= Valid_1;
    end


end

assign Filter_Out = accum;
assign Valid_out_ema  = Valid_1;
endmodule

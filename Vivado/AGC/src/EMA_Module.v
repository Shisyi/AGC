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
    input  wire [DWIDTH-1:0     ] Port_Data,
    input  wire                   Valid,
    output wire                   Valid_out_ema,
    output wire [OUTWIDTH-1:0   ] Filter_Out
);

//reg signed [AWIDTH-1:0]   a;
reg signed [DWIDTH-1:0]   Data;
reg signed [BWIDTH-1:0]   Coeff_1,Coeff_2;
reg signed [DWIDTH-1:0]   Pread; 
//reg signed [MULT-1:0]     mult;
reg signed [OUTWIDTH-1:0] c,accum ;
reg Valid_1,Valid_2,Valid_3;


wire signed [DWIDTH+6:0] accum_shift;
wire signed [DWIDTH-1:0] accum_raunding;

//INMODE <= "11101";
assign accum_shift    = accum >> 14; // Сдвигаю вправо на 14 битов
assign accum_raunding = {accum_shift[DWIDTH+6],accum_shift[DWIDTH:0]}; // Выкидываю биты целой части, для одинаковой разрядности (1,27,18)

always @(posedge clk) begin
//    a1 <= accum;
    Valid_1 <= Valid;
    if (Valid) begin
        Data    <= Port_Data;
    end
    Coeff_1 <= Filter_Coefficient;
    Valid_2 <= Valid_1;
    Pread   <= Data  - accum_raunding; // Преэддер: Data(1,27,18) и accum(1,48,32), =>  32 до 18 сдвигом вправо на 14, (1,34,18), и убираем 7 бита из целой части.
    Coeff_2 <= Coeff_1;
//    mult     = Coeff * Pread;
    if (Valid_2) begin
        accum   <= Coeff_2 * Pread + c;
        Valid_3 <= Valid_2;
    end

    if (Valid_3) begin
        c     <= accum;
    end

end

assign Filter_Out = accum;
assign Valid_out_ema  = Valid_2;

endmodule

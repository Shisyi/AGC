`timescale 1ns / 1ps

module Error
#(   
    parameter BWIDTH = 13,
    parameter AWIDTH = 27,
    parameter DWIDTH = 8,
//    parameter MULT = 45,
    parameter OUTWIDTH = 48  //parameter
) (
    input  wire clk,
    input  wire [BWIDTH-1:0     ] Error_Coefficient,
    input  wire [AWIDTH-1:0     ] Port_Data_A,
    input  wire [DWIDTH-1:0     ] R_level,
    input  wire                   Valid,
    output wire                   Valid_out_error,
    output wire [OUTWIDTH-1:0   ] Error_Out
);
reg signed [AWIDTH-1:0]   Data = 0;
reg        [BWIDTH-1:0]   Coeff_2 = 0;
reg        [BWIDTH-1:0]   Coeff_1 = 0;
reg signed [DWIDTH-1:0]   Pread = 0;
reg        [DWIDTH-1:0]   R_trig = 0; 
reg signed [OUTWIDTH-1:0] accum = 0;
reg signed [OUTWIDTH-1:0] c = 0;
reg Valid_1,Valid_2;

always @(posedge clk) begin

	R_trig  <= R_level;
	Valid_1 <= Valid;
	Coeff_1 <= Error_Coefficient;
	Data    <= Port_Data_A;

    Pread   <= $signed({1'b0,R_trig})  - Data;
	Valid_2 <= Valid_1;
	Coeff_2 <= Coeff_1;

	if (Valid_2) begin
		accum <= $signed({{5{1'b0}},Coeff_2}) * Pread + c;
	end

	c <= accum;

end

assign Valid_out_error = Valid_2;
assign Error_Out = accum;

endmodule

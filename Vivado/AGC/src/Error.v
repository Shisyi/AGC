`timescale 1ns / 1ps

module Error
#(   
    parameter BWIDTH = 18,
    parameter AWIDTH = 30,
    parameter DWIDTH = 27,
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
reg signed [AWIDTH-1:0]   Data;
reg signed [BWIDTH-1:0]   Coeff_1,Coeff_2;
reg signed [DWIDTH-1:0]   Pread;
reg signed [DWIDTH-1:0]   R_trig; 
reg signed [OUTWIDTH-1:0] c,accum ;
reg Valid_1,Valid_2;

always @(posedge clk) begin

	R_trig  <= R_level;
	Valid_1 <= Valid;
	Coeff_1 <= Error_Coefficient;
	Data    <= Port_Data_A;

    Pread   <= R_trig  - Data;
	Valid_2 <= Valid_1;
	Coeff_2 <= Coeff_1;
	if (Valid_2) begin
		accum   <= Coeff_2 * Pread + c;
	end
	c 		<= accum;
end

assign Valid_out_error = Valid_2;
assign Error_Out = accum;

endmodule

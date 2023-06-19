`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.06.2023 23:12:12
// Design Name: 
// Module Name: AGC_Module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AGC_Module#(
    parameter W_IN    = 16,
    parameter W_OUT   = 16,
    parameter W_ALPHA = 16,
    parameter F_ALPHA = 14,
    parameter W_REF   = 16,
    parameter F_REF   = 14,
    parameter W_A     = 16,
    parameter F_A     = 14
) (
    input  wire                          clk           ,
    input  wire                          reset         ,
    input  wire [W_ALPHA-1:0]            i_alpha       , // Speed 
    input  wire [  W_REF-1:0]            i_reference   , // Referenne level
    input  wire [  W_REF-1:0]            i_a           , // Filter coefficient
    input  wire [   W_IN-1:0]            s_chans_dataI , // Image
    input  wire [   W_IN-1:0]            s_chans_dataQ , // ReaL
    input  wire                          s_chans_valid , // Valid input
    output wire [  W_OUT-1:0]            m_chans_data  , // Output data
    output wire                          m_chans_valid   // Valid output
);

reg   
	signI,
	signQ;

reg   [W_IN-2:0]
    module_dataI,
    module_dataQ;

reg   [W_IN-1:0]
	received_sum;

reg signed  [W_OUT-1:0]
	b,d,filter;

    EMA_module #(
    .AWIDTH  (    W_IN),
    .BWIDTH  (     W_A),
    .OUTWIDTH(   W_OUT),
    .DWIDTH  (    W_IN),
    .MULT    (    W_OUT),
) uut (
    .clk(clk),
    .b_in(b),
    .d_in(d),
    .out(filter)
);

assign	signI = s_chans_dataI[W_IN-1];
assign	signQ = s_chans_dataQ[W_IN-1];

always @(posedge clk) begin
	case (signI)	
		1'b0 :  module_dataI <=  s_chans_dataI;
		1'b1 :  module_dataI <= -s_chans_dataI;
	endcase
		case (signQ)	
		1'b0 :  module_dataQ <=  s_chans_dataQ;
		1'b1 :  module_dataQ <= -s_chans_dataQ;
	endcase

	if (s_chans_valid) begin
		received_sum <= module_dataQ + module_dataI;
	end


end	

endmodule

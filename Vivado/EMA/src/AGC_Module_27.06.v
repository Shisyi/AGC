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

reg   [W_IN-1:0]
	received_Isignal,received_Qsignal;

reg   [27-1:0]
    first_Imult,first_Qmult;

reg   
    signI,
    signQ;    

wire   [27-1:0]
    module_dataI,
    module_dataQ; 

reg    [27-1:0]
    received_sum;       

reg signed  [41-1:0]
	filter;

	EMA_Module #(
		.BWIDTH(18),
		.AWIDTH(30),
		.DWIDTH(27),
		.MULT(45),
		.OUTWIDTH(48)
	) inst_EMA_Module (
		.clk  (clk),
		.b_in (i_a),
		.d_in (received_sum),
		.out  (filter)
	);

reg [10-1:0]
    out_chance;

    

always @(posedge clk) begin

    if(s_chans_valid)
        received_Isignal <= s_chans_dataI;
        received_Qsignal <= s_chans_dataQ;
    end

    first_Imult <= received_Isignal * out_chance;
    first_Qmult <= received_Qsignal * out_chance;

end 

assign  signI = first_Imult[27-1];
assign  signQ = first_Qmult[27-1];

always @* begin : async_proc
    case (signI)
        1'b0 : module_dataI <=  first_Imult;
        1'b1 : module_dataI <= -first_Imult;
    endcase
        case (signQ)
        1'b0 : module_dataQ <=  first_Qmult;
        1'b1 : module_dataQ <= -first_Qmult;
    endcase
end

always @(posedge clk) begin

    received_sum <= module_dataQ + module_dataI;

end

always @(posedge clk) begin

    received_sum <= module_dataQ + module_dataI;

end  

endmodule

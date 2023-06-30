`timescale 1ns / 1ps



module Test1
	#(   
    parameter W_IN = 16,
    parameter W_IN_MODULE = 26,
    parameter BWIDTH = 18,
    parameter W_OUT = 48
) (
    input  wire clk,
    input  wire [W_IN -1:0 ] s_chans_dataI,
    input  wire [W_IN -1:0 ] s_chans_dataQ,
    input  wire 			 s_chans_valid,
    input  wire [BWIDTH-1:0] Filter_Coefficient,
    output wire 			 Valid_Out,
    output wire [W_OUT-1:0 ] Output
);


wire [W_IN_MODULE:0] 
	connection;

wire
	valid_connection;

reg   [0:0]
    Valid_1,Valid_2;

reg   [W_IN-1:0]
	received_Isignal,received_Qsignal;

reg   [W_IN_MODULE-1:0]
    first_Imult,first_Qmult;

reg [10-1:0]
    out_chance = 1'b0000000001;

always @(posedge clk) begin

    if(s_chans_valid) begin
        received_Isignal <= s_chans_dataI;
        received_Qsignal <= s_chans_dataQ;
    end

    first_Imult <= received_Isignal * out_chance;
    first_Qmult <= received_Qsignal * out_chance;
    Valid_1     <= s_chans_valid;
    Valid_2     <= Valid_1;
 end


    Module_of_number #(
        .W_IN(W_IN_MODULE),
        .W_OUT(W_IN_MODULE+1)
    ) inst_Module_of_number (
        .clk       (clk),
        .Input_a   (first_Imult),
        .Input_b   (first_Qmult),
        .Valid     (Valid_2),
        .Valid_out_module (valid_connection),
        .Output    (connection)
    );

	EMA_Module #(
		.BWIDTH(BWIDTH),
		.DWIDTH(W_IN_MODULE+1),
		.OUTWIDTH(W_OUT)
	) inst_EMA_Module (
		.clk  (clk),
		.Filter_Coefficient (Filter_Coefficient),
		.Data (connection) ,
		.Valid (valid_connection),
		.Valid_out_ema (Valid_Out),
		.Filter_Out (Output)
	);

endmodule

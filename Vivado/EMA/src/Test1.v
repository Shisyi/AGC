`timescale 1ns / 1ps

module Test1
    #(   
    parameter W_IN = 16,
    parameter W_IN_MODULE = 26,
    parameter BWIDTH = 18,
    parameter AWIDTH = 30,
    parameter DWIDTH = 27,
    parameter W_OUT = 16
) (
    input  wire clk,
    input  wire [W_IN -1:0 ] s_chans_dataI,
    input  wire [W_IN -1:0 ] s_chans_dataQ,
    input  wire              s_chans_valid,
    input  wire [BWIDTH-1:0] Filter_Coefficient,
    input  wire [BWIDTH-1:0] Error_Coefficient,
    input  wire [DWIDTH-1:0] R_level,
    output wire              Valid_Out,
    output wire [W_OUT-1:0 ] OutputI,
    output wire [W_OUT-1:0 ] OutputQ
);


wire [W_IN_MODULE:0] connection;
wire [AWIDTH-1:0   ] error_connect;
wire [W_OUT-1:0    ] error_last;  
wire valid_connection,valid_error,valid_out_error;

reg   [0:0]  Valid_1,Valid_2;

reg   [W_IN-1:0] received_Isignal,received_Qsignal;

reg   [W_IN_MODULE-1:0] first_Imult,first_Qmult;

wire  [W_IN-1:0] Satureted_real,Satureted_imag;

reg   [W_OUT-1:0] I_out_reg,Q_out_reg;

    
    assign Valid_Out  = valid_out_error;
    assign OutputQ    = Q_out_reg;
    assign OutputI    = I_out_reg;


always @(posedge clk) begin

    if(s_chans_valid) begin
        received_Isignal <= s_chans_dataI;
        received_Qsignal <= s_chans_dataQ;
    end



    first_Imult <= received_Isignal * error_last;
    first_Qmult <= received_Qsignal * error_last;
    Valid_1     <= s_chans_valid;
    Valid_2     <= Valid_1;

    if (Valid_Out)begin
        Q_out_reg     = Satureted_real;
        I_out_reg     = Satureted_imag;
    end
 end
    Overflow_Satureted #(
        .W_IN(W_IN_MODULE), 
        .W_OUT(W_IN)
    ) 
    inst_Overflow_Satureted_real 
    (
        .Data_In(first_Qmult),
        .Saturated_Out(Satureted_real)
    );

        Overflow_Satureted #(
        .W_IN(W_IN_MODULE), 
        .W_OUT(W_IN)
    ) 
    inst_Overflow_Satureted_imag 
    (
        .Data_In(first_Imult),
        .Saturated_Out(Satureted_imag)
    );


    Module_of_number #(
        .W_IN(W_IN_MODULE),
        .W_OUT(W_IN_MODULE+1)
    ) inst_Module_of_number (
        .Input_a   (first_Imult),
        .Input_b   (first_Qmult),
        .Output    (connection)
    );

    EMA_Module #(
        .BWIDTH(BWIDTH),
        .DWIDTH(DWIDTH),
        .OUTWIDTH(W_OUT)
    ) inst_EMA_Module (
        .clk  (clk),
        .Filter_Coefficient (Filter_Coefficient),
        .Port_Data (connection) ,
        .Valid (Valid_2),
        .Valid_out_ema (valid_error),
        .Filter_Out (error_connect)
    );

    Error #(
        .BWIDTH(BWIDTH),
        .AWIDTH(AWIDTH),
        .DWIDTH(DWIDTH),
        .OUTWIDTH(W_OUT)
    ) inst_Error (
        .clk               (clk),
        .Error_Coefficient (Error_Coefficient),
        .Port_Data_A       (error_connect),
        .R_level           (R_level),
        .Valid             (valid_error),
        .Valid_out_error   (valid_out_error),
        .Error_Out         (error_last)
    );

endmodule
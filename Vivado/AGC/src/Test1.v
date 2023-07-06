`timescale 1ns / 1ps

module Test1
    #(   
    parameter W_IN = 16,
    parameter W_IN_MODULE = 26,
    parameter BWIDTH = 18,
    parameter FILTERWIDTH = 13,
    parameter AWIDTH = 30,
    parameter DWIDTH = 27,
    parameter RWIDTH = 8,
    parameter DSPWIDTH = 48,
    parameter W_OUT = 16
) (
    input  wire clk,
    input  wire [W_IN -1:0  	] s_chans_dataI,
    input  wire [W_IN -1:0  	] s_chans_dataQ,
    input  wire              	  s_chans_valid,
    input  wire [FILTERWIDTH-1:0] Filter_Coefficient,
    input  wire [FILTERWIDTH-1:0] Error_Coefficient,
    input  wire [RWIDTH-1:0     ] R_level,
    output wire              	  Valid_Out,
    output wire [W_IN_MODULE-1:0] OutputI,
    output wire [W_IN_MODULE-1:0] OutputQ
);


wire signed [W_IN_MODULE:0] connection; // Разрядность 27,18. Выход с ||

wire signed [DSPWIDTH-1:0 ] Dsp1_Out;   // Выход с первого фильтра
wire signed [DWIDTH+6:0   ] Dsp1_Shift; // Сдвинутая дата на 14 вправо
wire signed [DWIDTH-1:0   ] Dsp1_Round; // Округлил убрав последние 7 бит

wire [DWIDTH-1:0   ] R_with_zeros;
wire signed [DSPWIDTH-1:0 ] error_last;

wire signed [DWIDTH+6:0   ] Dsp2_Shift; // Сдвинутая дата на 14 вправо
wire signed [DWIDTH-1:0   ] Dsp2_Round; // Округлил убрав последние 7 бит


wire valid_connection,valid_error,valid_out_error;

reg   [0:0]  Valid_1,Valid_2;

reg  signed [W_IN-1:0] received_Isignal,received_Qsignal;

reg  signed [43-1:0         ] first_Imult,first_Qmult;
wire signed [W_IN_MODULE-1:0] first_Imult_round,first_Qmult_round;

wire signed [W_IN-1:0] Satureted_real,Satureted_imag;

reg  signed [W_IN_MODULE-1:0] I_out_reg,Q_out_reg;

    
    assign Valid_Out  = valid_out_error;
    assign OutputQ    = Q_out_reg;
    assign OutputI    = I_out_reg;


always @(posedge clk) begin

    if(s_chans_valid) begin
        received_Isignal <= s_chans_dataI; //Записываю 16,14 входные данные в триггер
        received_Qsignal <= s_chans_dataQ; //Записываю 16,14 входные данные в триггер
    end



    first_Imult <= received_Isignal * Dsp2_Round; // 16,14 умножаю на ...
    first_Qmult <= received_Qsignal * Dsp2_Round; // 16,14 умножаю на ...
    Valid_1     <= s_chans_valid;
    Valid_2     <= Valid_1;

    if (Valid_Out)begin
        Q_out_reg     = first_Imult_round; // Отправляю валидный сигнал на выход устройства
        I_out_reg     = first_Qmult_round; // Отправляю валидный сигнал на выход устройства
    end

//    if (Valid_Out)begin
//        Q_out_reg     = Satureted_real;
//        I_out_reg     = Satureted_imag;
//    end
 end

assign Dsp1_Shift = Dsp1_Out >> 14; // Выход дсп (48,32) - Сдвинул на 14 право (34,18)
assign Dsp1_Round = {Dsp1_Shift[DWIDTH+6],Dsp1_Shift[DWIDTH:0]}; // Убрал лишнюю разрядность целой части, с добавлением знакового разряда

assign R_with_zeros = {7'b0000000,R_level,12'b000000000000};
                
assign Dsp2_Shift = error_last >> 14; // Выход дсп (48,32) - Сдвинул на 14 право (34,18)
assign Dsp2_Round = {Dsp2_Shift[DWIDTH+6],Dsp2_Shift[DWIDTH:0]};

assign first_Imult_round = first_Imult >> 17;
assign first_Qmult_round = first_Qmult >> 17;
//    Overflow_Satureted #(
//        .W_IN(W_IN_MODULE), 
//        .W_OUT(W_IN)
//    ) 
//    inst_Overflow_Satureted_real 
//    (
//        .Data_In(first_Qmult),
//        .Saturated_Out(Satureted_real)
//    );

//        Overflow_Satureted #(
//        .W_IN(W_IN_MODULE), 
//        .W_OUT(W_IN)
//    ) 
//    inst_Overflow_Satureted_imag 
//    (
//        .Data_In(first_Imult),
//        .Saturated_Out(Satureted_imag)
//    );


    Module_of_number #(
        .W_IN(W_IN_MODULE), // На модуль поступает сигнал разрядностью 26,18
        .W_OUT(W_IN_MODULE+1) // На выходе модуля сигнал разрядностью 27,18
    ) inst_Module_of_number (
        .Input_a   (first_Imult_round),
        .Input_b   (first_Qmult_round),
        .Output    (connection)
    );

    EMA_Module #(
        .BWIDTH(FILTERWIDTH), // Разрядность коэффициента умножения фильтра 0,13,13
        .DWIDTH(DWIDTH), // Разрядность порта даты 27,18 как с выхода ||
        .OUTWIDTH(DSPWIDTH) 
    ) inst_EMA_Module (
        .clk  (clk),
        .Filter_Coefficient (Filter_Coefficient),
        .Port_Data (connection) ,
        .Valid (Valid_2),
        .Valid_out_ema (valid_error),
        .Filter_Out (Dsp1_Out)
    );

    Error #(
        .BWIDTH(FILTERWIDTH),
        .AWIDTH(DWIDTH),
        .DWIDTH(DWIDTH),
        .OUTWIDTH(DSPWIDTH)
    ) inst_Error (
        .clk               (clk),
        .Error_Coefficient (Error_Coefficient),
        .Port_Data_A       (Dsp1_Round),
        .R_level           (R_with_zeros),
        .Valid             (valid_error),
        .Valid_out_error   (valid_out_error),
        .Error_Out         (error_last)
    );

endmodule
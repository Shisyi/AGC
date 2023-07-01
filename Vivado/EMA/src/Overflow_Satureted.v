`timescale 1ns / 1ps


module Overflow_Satureted
#(   
    parameter W_IN = 26,
    parameter W_OUT = 16
) (
    input  wire [W_IN-1:0     ] Data_In,
    output wire [W_OUT-1:0 ] Saturated_Out
);

assign Saturated_Out = Data_In[W_IN-1:10]+Data_In[9];

endmodule

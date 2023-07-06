`timescale 1ns / 1ps


module Module_of_number
#(   
    parameter W_IN = 26,
    parameter W_OUT = 27
) (
    input  wire [W_IN -1:0 ] Input_a,
    input  wire [W_IN -1:0 ] Input_b,
    output wire [W_OUT-1:0 ] Output

);

wire  sign_a, sign_b;    

reg   [W_IN-1:0] module_a, module_b;
 

assign  sign_a = Input_a[W_IN-1];
assign  sign_b = Input_b[W_IN-1];

always @* begin : async_proc
    case (sign_a)
        1'b0 : module_a =  Input_a;
        1'b1 : module_a = -Input_a;
    endcase
    case (sign_b)
        1'b0 : module_b =  Input_b;
        1'b1 : module_b = -Input_b;
    endcase
end



assign Output  = module_a + module_b;

endmodule

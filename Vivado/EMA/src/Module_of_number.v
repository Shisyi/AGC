`timescale 1ns / 1ps


module Module_of_number
#(   
    parameter W_IN = 26,
    parameter W_OUT = 27
) (
    input  wire clk,
    input  wire [W_IN -1:0 ] Input_a,
    input  wire [W_IN -1:0 ] Input_b,
    input  wire 			 Valid,
    output wire              Valid_out_module,
    output wire [W_OUT-1:0 ] Output

);

wire  
    sign_a,
    sign_b;    

reg   [W_IN-1:0]
    module_a,
    module_b;

reg Valid_delay; 

reg   [W_OUT-1:0]
    received_sum;  

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

always @(posedge clk) begin
	Valid_delay <= Valid;
	if (Valid_delay) begin
    	received_sum <= module_a + module_b;
    end
end

assign Output  = received_sum;
assign Valid_out_module = Valid_delay;

endmodule

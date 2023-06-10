`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2023 22:37:09
// Design Name: 
// Module Name: Sim_sistem_DSP
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


module Sim_sistem_DSP;

  localparam AWIDTH = 16, OUTWIDTH = 33;  //parameter
  wire signed [AWIDTH-1:0]   a_real, a_imag, b_real, b_imag;
  reg  signed [OUTWIDTH-1:0] z_real, z_imag;
  
    Multiplayer UUT (.a_real(a_real), .b_real(b_real), .a_imag(a_imag), .b_imag(b_imag));
    
begin  
    a_real <= 16b0000000011111111 ;
    a_imag <= 16b0000000000000011 ;
    b_real <= 16b0000000011111111 ;
    b_imag <= 16b0000000000000011 ;
end
endmodule

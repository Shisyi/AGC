`timescale 1ns / 1ps

module complex_mult
#(
    parameter AWIDTH = 16,
    parameter BWIDTH = 16,
    parameter OUTWIDTH = 33  //parameter
) (
    input  wire clk,
    input  wire [  AWIDTH-1:0] a_real,
    input  wire [  AWIDTH-1:0] a_imag,
    input  wire [  BWIDTH-1:0] b_real,
    input  wire [  BWIDTH-1:0] b_imag,
    input  wire                 valid,
    output wire [OUTWIDTH-1:0] z_real,
    output wire [OUTWIDTH-1:0] z_imag
);

    reg  signed [AWIDTH-1:0]
    dsp1_trig1_1, dsp1_trig1_2,dsp1_trig1_3,dsp1_trig2_1,
    dsp2_trig1_1, dsp2_trig1_2,dsp2_trig1_3,dsp2_trig2_1,
    dsp3_trig1_1, dsp3_trig1_2,dsp3_trig1_3,dsp3_trig2_1;
    
    reg  signed [AWIDTH:0]
        dsp1_adder_1,dsp2_adder_1,dsp3_adder_1;
    
    reg  signed [OUTWIDTH-2:0]
        dsp1_mult,dsp2_mult,dsp3_mult,
        dsp1_mult_del,dsp2_mult_del,dsp3_mult_del;
    
    reg  signed [OUTWIDTH-1:0]
        dsp1_adder_2,dsp3_adder_2,
        dsp1_adder_2_del,dsp3_adder_2_del;
    
    reg signed [OUTWIDTH-1:0] z_real_int;
    reg signed [OUTWIDTH-1:0] z_imag_int;

 //// Stage one: reg at all input signals

always @(posedge clk) begin
    if (valid) begin
        // First DSP
        dsp1_trig1_1 <= b_imag;
        dsp1_trig1_2 <= a_real;
        dsp1_trig1_3 <= a_imag;
        //Second DSP
        dsp2_trig1_1 <= a_real;
        dsp2_trig1_2 <= b_real;
        dsp2_trig1_3 <= b_imag;
        //Third DSP
        dsp3_trig1_1 <= b_real;
        dsp3_trig1_2 <= a_real;
        dsp3_trig1_3 <= a_imag;
    end
end


//// Stage two:
always @(posedge clk) begin
        //First DSP
        dsp1_trig2_1    <=      dsp1_trig1_1;
        dsp1_adder_1    <=      dsp1_trig1_2 + dsp1_trig1_3;

        //Second DSP
        dsp2_trig2_1    <=      dsp2_trig1_1;
        dsp2_adder_1    <=      dsp2_trig1_2 + dsp2_trig1_3;

        //Third DSP
        dsp3_trig2_1    <=      dsp3_trig1_1;
        dsp3_adder_1    <=      dsp3_trig1_3 - dsp3_trig1_2;
end
///////Dop Zadergka


  ////Stage three
always @(posedge clk)
    begin
        //First DSP
        dsp1_mult       <=      dsp1_trig2_1 * dsp1_adder_1;
        //Second DSP
        dsp2_mult       <=      dsp2_trig2_1 * dsp2_adder_1;
        //Third DSP
        dsp3_mult       <=      dsp3_trig2_1 * dsp3_adder_1;
    end
//// Stage four
always @(posedge clk)
   begin

        //First DSP
        dsp1_mult_del   <=      dsp1_mult;
        //Second DSP
        dsp2_mult_del   <=      dsp2_mult;
        //Third DSP
        dsp3_mult_del   <=      dsp3_mult;
    end
  //// Stage five
always @(posedge clk)
    begin
        // First DSP
        dsp1_adder_2    <=      dsp2_mult_del-dsp1_mult_del;
        // Second DSP
        dsp3_adder_2    <=      dsp2_mult_del+dsp3_mult_del;
    end
  //// Stage six
always @(posedge clk)
      begin
        // First DSP
        dsp1_adder_2_del <=     dsp1_adder_2;
        // Second DSP
        dsp3_adder_2_del <=     dsp3_adder_2;
      end
  //// Stage seven
always @(posedge clk)
    begin
        z_real_int       <=     dsp1_adder_2_del;
        z_imag_int       <=     dsp3_adder_2_del;
    end

    assign z_real = z_real_int;
    assign z_imag = z_imag_int;
endmodule





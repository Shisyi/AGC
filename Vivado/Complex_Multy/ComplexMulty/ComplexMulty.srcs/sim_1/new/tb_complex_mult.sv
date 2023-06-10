`timescale 1ns / 1ps

module tb_complex_mult();
    localparam AWIDTH = 16;
    localparam BWIDTH = 16;
    localparam OUTWIDTH = 33;
    localparam CLK_PERIOD = 10ns;

    logic clk = 0;
    logic [AWIDTH-1:0] a_real = 0;
    logic [AWIDTH-1:0] a_imag = 0;
    logic [BWIDTH-1:0] b_real = 0;
    logic [BWIDTH-1:0] b_imag = 0;
    logic [OUTWIDTH-1:0] z_real;
    logic [OUTWIDTH-1:0] z_imag;

    complex_mult #(
        .AWIDTH  (AWIDTH  ),
        .BWIDTH  (BWIDTH  ),
        .OUTWIDTH(OUTWIDTH)
    ) uut (
        .clk(clk),
        .a_real(a_real),
        .a_imag(a_imag),
        .b_real(b_real),
        .b_imag(b_imag),
        .z_real(z_real),
        .z_imag(z_imag)
    );

    initial begin
        forever begin
            clk <= !clk;
            #(CLK_PERIOD/2);
        end
    end

    task wait_clk(int num_clk);
        #(num_clk * CLK_PERIOD);
    endtask : wait_clk

    initial begin
        @(posedge clk);

        wait_clk(10);

        a_real <= 16'd1;
        b_real <= 16'd3;
        a_imag <= 16'd1;
        b_imag <= 16'd2;

        wait_clk(10);

        a_real <= 16'd1;
        b_real <= 16'd2;
        a_imag <= 16'd1;
        b_imag <= 16'd2;

        wait_clk(10);

        $stop;
    end

endmodule

`timescale 1ns / 1ps

module tb_complex_mult();
    localparam AWIDTH = 16;
    localparam BWIDTH = 16;
    localparam OUTWIDTH = 33;
    localparam CLK_PERIOD = 10ns;


    localparam files_dir = "D:/Matlab/Folder's/FAR/BeforeGit/2023.04.25/";

    localparam file_name_data  =  {files_dir, "Data.txt"};
    localparam file_name_curr  =  {files_dir, "DataCurr.txt"};
    localparam file_name_write =  {files_dir, "DataVivado.txt"};


    int fp_r1,fp_r2,fp_w;

    logic clk = 0;
    logic [AWIDTH-1:0] a_real = 0;
    logic [AWIDTH-1:0] a_imag = 0;
    logic [BWIDTH-1:0] b_real = 0;
    logic [BWIDTH-1:0] b_imag = 0;
    logic [OUTWIDTH-1:0] z_real ;
    logic [OUTWIDTH-1:0] z_imag ;
    logic                valid;
    complex_mult #(
        .AWIDTH  (AWIDTH  ),
        .BWIDTH  (BWIDTH  ),
        .OUTWIDTH(OUTWIDTH)
    ) uut (
        .valid(valid),
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

    logic [15:0] rd_value1;
    logic [15:0] rd_value2;
    logic [15:0] rd_value3;
    logic [15:0] rd_value4;

    initial begin
        fp_r1 = $fopen(file_name_data, "r");
        if (!fp_r1) begin
            $display("File not opened %s", file_name_data);
            $stop;
        end

        fp_r2 = $fopen(file_name_curr, "r");
        if (!fp_r2) begin
            $display("File not opened %s", file_name_curr);
            $stop;
        end

        fp_w = $fopen(file_name_write, "w");
        if (!fp_w) begin
            $display("File not opened %s", file_name_write);
            $stop;
        end

        @(posedge clk);
        wait_clk(10);
        valid <= 1;

        while (!$feof(fp_r1)) begin
            $fscanf(fp_r1, "%d n", rd_value1);
                    a_real <= rd_value1;
            $fscanf(fp_r1, "%d /n", rd_value1);
                    a_imag <= rd_value1;
            $fscanf(fp_r2, "%d n", rd_value2);
                    b_real <= rd_value2;
            $fscanf(fp_r2, "%d /n", rd_value2);
                    b_imag <= rd_value2;

            $fmonitor(fp_w, "%d ",$signed(z_real));

            $fmonitor(fp_w, "%d ",$signed(z_imag));

            wait_clk(1);

        end

        $display("Done");
        $fclose(fp_r1);
        $fclose(fp_r2);
        $fclose(fp_w);

        $stop;
    end

endmodule

`timescale 1ns / 1ps


module TestBench_one();

	parameter        W_IN = 16;
	parameter W_IN_MODULE = 26;
	parameter      BWIDTH = 18;
	parameter FILTERWIDTH = 13;
	parameter      AWIDTH = 30;
	parameter      DWIDTH = 27;
	parameter      RWIDTH = 8;
	parameter    DSPWIDTH = 48;
	parameter       W_OUT = 16;

    localparam CLK_PERIOD = 10ns;
    localparam files_dir         =  "D:/Matlab/Folder's/FAR/AfterGit/AGC/Simulink/Second_Folder/";

    localparam file_name_data    =  {files_dir, "Data.txt"};

    localparam file_name_Filter  =  {files_dir, "Filter.txt"};
    localparam file_name_Error   =  {files_dir, "Error.txt"};
    localparam file_name_R       =  {files_dir, "R.txt"};	

    localparam file_name_write   =  {files_dir, "DataVivado.txt"};

    int fp_r,fp_w,fp_fil,fp_err,fp_R;
    logic [15:0] rd_value;
    logic [7:0 ] rdr_value;


    logic clk = 0;
	logic      [W_IN -1:0 ] s_chans_dataI;
	logic      [W_IN -1:0 ] s_chans_dataQ;
	logic                   s_chans_valid;
	logic [FILTERWIDTH-1:0] Filter_Coefficient;
	logic [FILTERWIDTH-1:0] Error_Coefficient;
	logic     [RWIDTH-1:0 ] R_level;
	logic                   Valid_Out;
	logic [W_IN_MODULE-1:0] OutputI;
	logic [W_IN_MODULE-1:0] OutputQ;

	Test1 #(
			.W_IN(W_IN),
			.W_IN_MODULE(W_IN_MODULE),
			.BWIDTH(BWIDTH),
			.FILTERWIDTH(FILTERWIDTH),
			.AWIDTH(AWIDTH),
			.DWIDTH(DWIDTH),
			.RWIDTH(RWIDTH),
			.DSPWIDTH(DSPWIDTH),
			.W_OUT(W_OUT)
		) inst_Test1 (
			.clk                (clk),
			.s_chans_dataI      (s_chans_dataI),
			.s_chans_dataQ      (s_chans_dataQ),
			.s_chans_valid      (s_chans_valid),
			.Filter_Coefficient (Filter_Coefficient),
			.Error_Coefficient  (Error_Coefficient),
			.R_level            (R_level),
			.Valid_Out          (Valid_Out),
			.OutputI            (OutputI),
			.OutputQ            (OutputQ)
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
    	s_chans_dataI      <= '0;
		s_chans_dataQ      <= '0;
		s_chans_valid      <= '0;
		Filter_Coefficient <= '0;
		Error_Coefficient  <= '0;
		R_level            <= '0;
		wait_clk(10);


		fp_r = $fopen(file_name_data, "r");
		    if (!fp_r) begin
		        $display("File not opened %s", file_name_data);
		        $stop;
		    end

		fp_w = $fopen(file_name_write, "w");
		    if (!fp_w) begin
		        $display("File not opened %s", file_name_write);
		        $stop;
		    end

        while (!$feof(fp_r)) begin

    		$fscanf(fp_r, "%d n", rd_value);
           		s_chans_dataI <= rd_value;

    		$fscanf(fp_r, "%d /n", rd_value);
            	s_chans_dataQ <= rd_value;

			fp_fil = $fopen(file_name_Filter, "r");
			    if (!fp_fil) begin
			        $display("File not opened %s", file_name_Filter);
			        $stop;
			    end
			$fscanf(fp_fil, "%d", Filter_Coefficient);
			$fclose(fp_fil);

			fp_err = $fopen(file_name_Error, "r");
			    if (!fp_err) begin
			        $display("File not opened %s", file_name_Error);
			        $stop;
			    end
			$fscanf(fp_err, "%d", Error_Coefficient);
			$fclose(fp_err);

			fp_R = $fopen(file_name_R, "r");
			    if (!fp_R) begin
			        $display("File not opened %s", file_name_R);
			        $stop;
			    end
			$fscanf(fp_R,   "%d", rdr_value);
				R_level<= rdr_value;	
            $fclose(fp_R);

        	$fdisplay(fp_w, "%d ",$signed(OutputI));
        	$fdisplay(fp_w, "%d ",$signed(OutputQ));

        	s_chans_valid <= 1;
        	wait_clk(1);
			s_chans_valid <= 0;
        	wait_clk(39); 
       	end

       	$display("Done");
       	$fclose(fp_r);
        $fclose(fp_w);
        $stop;
    end
 
endmodule

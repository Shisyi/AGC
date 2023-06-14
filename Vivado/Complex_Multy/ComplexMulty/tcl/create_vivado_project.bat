@echo off

call D:\Vivado\Xilinx\Vivado\2022.2\settings64.bat

call vivado -nojournal -mode batch -source create_vivado_project.tcl

pause
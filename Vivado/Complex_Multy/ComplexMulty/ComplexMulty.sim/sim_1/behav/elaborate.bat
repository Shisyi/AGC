@echo off
set xv_path=D:\\Vivado\\Vivado\\2016.3\\bin
call %xv_path%/xelab  -wto f2921417f3f24de39ae28993a8b11788 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_complex_mult_behav xil_defaultlib.tb_complex_mult xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0

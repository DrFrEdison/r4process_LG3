@echo off
REM Set the path to Rscript.exe
set Rscript_path="D:\r4dt_LG3\R-Portable\App\R-Portable\bin\Rscript.exe"

REM Set the path to the R script
set R_script_path="D:\r4dt_LG3\function\LG3_spectral_analysis.R"

REM Set the path to the logfile
set logfile_path="%script_dir%\plot_analysis.log"

REM Run the R script with the filename as an argument
%Rscript_path% %R_script_path% "%~n0" > %logfile_path%




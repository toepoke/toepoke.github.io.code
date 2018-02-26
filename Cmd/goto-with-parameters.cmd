@echo off
REM
REM Windows: Illustrates calling a subroutine in batch files.
REM

@echo off

call :MySub test
call :MySub test2

goto :eof

:MySub
	echo %1 %2
	



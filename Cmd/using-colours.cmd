@echo off
REM
REM Windows: Illustrates calling a subroutine in batch files.
REM
REM From here (I have no idea what it's doing!)
REM https://stackoverflow.com/questions/2048509/how-to-echo-with-different-colors-in-the-windows-command-line

SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)

call :ColorText 0a "green"
echo.
call :ColorText 0C "red"
call :ColorText 0b "cyan"
echo(
call :ColorText 19 "blue"
call :ColorText 2F "white"
call :ColorText 4e "yellow"

goto :eof

:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
goto :eof




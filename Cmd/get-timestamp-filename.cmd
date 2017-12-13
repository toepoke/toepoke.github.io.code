REM
REM Windows: Converts the current DATE and TIME into a filename friendly string
REM
@echo off

echo.
echo Based on UK Date Format, given:
echo.
echo Current Date	= 04/12/2017
echo Current Time	= 11:00:23.35
echo TimeStamp 		= 20171204_110023
echo.
echo Basically %%DATE:~6,4%% is a substring operation which is zero index, so %%DATE:~6,4%% gets the YEAR portion
set TimeStamp=%DATE:~6,4%%DATE:~3,2%%DATE:~0,2%_%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%

echo Example:
echo ----------------
echo Current Date: %DATE%
echo Current Time: %TIME%
echo %TimeStamp%
echo.
echo.


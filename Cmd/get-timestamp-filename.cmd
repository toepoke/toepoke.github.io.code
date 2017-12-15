@echo off
REM
REM Windows: Converts the current DATE and TIME into a filename friendly string
REM

echo.
echo Based on UK Date Format, given:
echo.
echo Current Date  =  04/12/2017
echo Current Time  =  11:00:23.35
echo.
echo TimeStamp would be:
echo TimeStamp     =  20171204_110023
echo.
echo Basically %%DATE:~6,4%% is a substring operation which is zero index, so %%DATE:~6,4%% gets the YEAR portion

set DATE_PART=%DATE:~6,4%%DATE:~3,2%%DATE:~0,2%
set TIME_PART=%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%

REM Time may have a leading space in the morning ( < 10am) - replace the space with a zero
set TIME_PART=%TIME_PART: =0%

set TimeStamp=%DATE_PART%_%TIME_PART%

echo Example:
echo ----------------
echo Current Date  =  %DATE%
echo Current Time  =  %TIME%
echo TimeStamp     =  %TimeStamp%
echo.

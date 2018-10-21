@echo off

Setlocal EnableDelayedExpansion
set DEBUG=0
set DB_SERVER_UNDER_TEST=
set DB_UNDER_TEST=
set REMOVE_TSQLT=0
set SQLCMD=%ProgramW6432%\Microsoft SQL Server\100\Tools\Binn\SQLCMD.EXE
set INSTALL=S:\Dropbox\Git\repo\toepoke.github.io.code\Sql\tSQLt
set InError=0

:PARSE_PARMS
	:: Environment variables may be set for a specific project in which case 
	:: we don't need to use the command-line parameters.
	if /I "%1"=="/h"  goto SHOW_SYNTAX
	if /I "%1"=="-h"  goto SHOW_SYNTAX
	if not "%1"=="" set DB_SERVER_UNDER_TEST=%1
	if not "%2"=="" set DB_UNDER_TEST=%2
	if not "%3"=="" set REMOVE_TSQLT=1

:RUN_CHECK
	:: Ensure environment variables are set in the file, or overriden by the command-line
	if "%DB_SERVER_UNDER_TEST%"=="" call :SHOW_HELP "Test database server not set" & goto SCRIPT_END
	if "%DB_UNDER_TEST%"==""        call :SHOW_HELP "Test database not set" & goto SCRIPT_END
	if "%SQLCMD%"==""               call :SHOW_HELP "SQLCMD environment variable not set" & goto SCRIPT_END
	if not exist "%SQLCMD%"         call :SHOW_HELP "SQLCMD tool not found" & goto SCRIPT_END
	if "%INSTALL%"==""              call :SHOW_HELP "INSTALL environment variable not set" & goto SCRIPT_END
	if not exist "%INSTALL%\."      call :SHOW_HELP "INSTALL directory not found" & goto SCRIPT_END	
	
:SCRIPT_START
	@echo ****************************************************
	@echo Testing : %DB_SERVER_UNDER_TEST%.%DB_UNDER_TEST%
	@echo ****************************************************

:INSTALL_TSQLT
	if %DEBUG%==1 @echo INSTALL_TSQLT::START
	copy /Y "%INSTALL%\tSQLt Install\*.sql" %TEMP%\_tSQLt.install.sql
	call :EXECUTE_SQL_SCRIPT %TEMP%\_tSQLt.install.sql
	if %DEBUG%==1 @echo INSTALL_TSQLT::FINISH
		
:RUN_ALL_SQL_TESTS
	if %DEBUG%==1 @echo RUN_ALL_SQL_TESTS::START
	for /F %%n in ('dir /s/b *.Tests.sql') do (
		set /a TotalTests=!TotalTests!+1
		@echo Running "%%n" ...
		if "%InError%"=="0" call :EXECUTE_SQL_SCRIPT %%n
		if ERRORLEVEL 1 call :TEST_FAILED %%n & goto SCRIPT_END
	)
	if %TotalTests%==0 call :TEST_FAILED "No tests found :-(" & goto SCRIPT_END
	if not %TotalTests%==0 echo Executed "%TotalTests%" test files ...
	if %DEBUG%==1 @echo RUN_ALL_SQL_TESTS::FINISH
	goto SCRIPT_END

:EXECUTE_SQL_SCRIPT
	:: %1 = Input file
	if %DEBUG%==1 @echo EXECUTE_SQL_SCRIPT::START
	if %DEBUG%==1 @echo sqlcmd -b -E -S %DB_SERVER_UNDER_TEST% -d %DB_UNDER_TEST% -i %1
	"%SQLCMD%" -b -E -S %DB_SERVER_UNDER_TEST% -d %DB_UNDER_TEST% -i %1 > %TEMP%\_tSQLt.test.execution.txt
	if ERRORLEVEL 1 set InError=1
	if "%InError%"=="1" type %TEMP%\_tSQLt.test.execution.txt
	exit /b %InError%
	if %DEBUG%==1 @echo EXECUTE_SQL_SCRIPT::FINISH
	goto :eof
	
:TEST_FAILED
	if %DEBUG%==1 @echo TEST_FAILED::START
	echo ******* TEST FAIL: %1
	if %DEBUG%==1 @echo TEST_FAILED::FINISH
	goto SCRIPT_END

:SCRIPT_END
	if %DEBUG%==1 @echo SCRIPT_END

:UNINSTALL_TSQLT
	if %DEBUG%==1 @echo UNINSTALL_TSQLT::START
	if "%REMOVE_TSQLT%"=="1" (
		@echo UNINSTALL_TSQLT
		copy /Y "%INSTALL%\tSQLt Uninstall\*.sql" %TEMP%\_tSQLt.uninstall.sql
		call :EXECUTE_SQL_SCRIPT %TEMP%\_tSQLt.uninstall.sql
	)
	if %DEBUG%==1 @echo UNINSTALL_TSQLT::START
	
:CLEAN_UP
	if %DEBUG%==1 @echo CLEAN_UP::START
	if exist %TEMP%\_tSQLt.install.sql          del /q %TEMP%\_tSQLt.install.sql
	if exist %TEMP%\_tSQLt.test.execution.txt   del /q %TEMP%\_tSQLt.test.execution.txt
	if exist %TEMP%\_tSQLt.install.sql          del /q %TEMP%\_tSQLt.install.sql	
	if exist %TEMP%\_tSQLt.uninstall.sql        del /q %TEMP%\_tSQLt.uninstall.sql
	if %DEBUG%==1 @echo CLEAN_UP::FINISH
	goto VERY_END
	
:SHOW_HELP
	echo ERROR: %1
:SHOW_SYNTAX
	echo.
	echo Run-tSQLt-Tests Usage:
	echo.
	echo   %%1  :  Database server under test
	echo   %%2  :  Database name/catalogue under test
	echo   %%3  :  if "1" tSQLt is uninstalled after running tests, otherwise it remains installed
	exit /b 1
	goto :eof

:VERY_END

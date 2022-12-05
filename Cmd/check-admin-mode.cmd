::
:: Example of how to check 
::

:AdminCheck
net session >nul 2>&1
if %errorLevel% == 0 (
	echo Success: Administrative permissions confirmed.
) else (
	echo Failure: Current permissions inadequate.
	goto :eof
)


@echo off
cls
::net users %USERNAME% /domain
::pause

:: Powershell gives a better output:
set UNAME=%USERNAME%
set /p UNAME=[Enter username (or empty for %USERNAME%)]

powershell -Command "& {(New-Object System.DirectoryServices.DirectorySearcher('(&(objectCategory=User)(samAccountName=%UNAME%))')).FindOne().GetDirectoryEntry().memberOf}"


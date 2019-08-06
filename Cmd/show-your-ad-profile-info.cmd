@echo off

set UNAME=%USERNAME%

if "%1"==""     set /p UNAME=[Enter username (or empty for %USERNAME%)]
if not "%1"=="" set UNAME=%1

powershell -Command "& {(New-Object System.DirectoryServices.DirectorySearcher('(&(objectCategory=User)(samAccountName=%UNAME%))')).FindOne().GetDirectoryEntry().memberOf}"

:: Probably double-clicked on the file, so pause for the results
if "%1"=="" pause



:: Development tools
winget install -e --id OpenJS.NodeJS.TLS
winget install -e --id Microsoft.NuGet
winget install -e --id Microsoft.VisualStudioCode
winget install -e --id Microsoft.VisualStudio.2022.Community
winget install -e --id WinMerge.WinMerge
winget install -e --id Microsoft.SQLServerManagementStudio
winget install -e --id Git.Git
winget install -e --id Microsoft.PowerShell
winget install -e --id Microsoft.AzureCLI

:: Utilities
winget install -e --id Microsoft.WindowsPCHealthCheck
winget install -e "Avast Free Antivirus"
winget install -e --id Google.Chrome
winget install -e --id Google.Chrome.Canary
winget install -e --id Notepad++.Notepad++
winget install -e --id IDRIX.VeraCrypt
winget install -e --id Microsoft.PowerToys

:: Optional (uncomment to install)
:: winget install -e --id  Microsoft.Azure.StorageExplorer

:: Productivity
winget install -e --id TheDocumentFoundation.LibreOffice

:: Outlook for Windows - doesn't work - fails to connect to the SMTP server, no error, nothing :(
:: winget install -e --id=9NRX63209R7B -i --source=msstore --accept-package-agreements

:: Dotnet tool
dotnet tool install --global dotnet-eft

:: Update packages collectively
winget upgrade --all

:: Try separately
	:: winget install -e --id Microsoft.SQLServer.2019.Developer --custom /SQLCOLLATION=SQL_Latin1_General_CP1_CI_AS

:: The following are portable installs:
	:: KeePass is a portable install

:: The following are manual
	:: Might be better doing VS manually
	:: Office do manually off network
	:: winget install --id Microsoft.VisualStudio.2022.Community  -e
	:: erazer
	:: adobe cs4
	:: IIS
	:: IIS rewrite module????
	:: https://www.7-zip.org/
	:: Brother iPrint&Scan

@echo off
echo Installing cnes...
cd /d C:\

REM Sets the execution policy to ignore all restrictions
Set-ExecutionPolicy Bypass -Scope Process -Force

REM Create a dedicated folder for installation
mkdir .\cnes
mkdir .\cnes\temp
cd cnes
cls

REM Install Chocolatey
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

REM Install wget and PowerShell Core
choco install wget -y
choco install powershell-core -y

REM Download cnes files
wget ftp://ftp.datasus.gov.br/cnes/Versoes-Fces-Nacional/SCNES4540-COMPLETA.zip
wget ftp://ftp.datasus.gov.br/cnes/Versoes-Fces-Nacional/SCNES4540-ATUALIZACAO.zip
wget ftp://ftp.datasus.gov.br/cnes/Versoes-Fces-Nacional/Instal_Firebird/InstaladorFirebird-155.zip

REM Downloading Java
curl -o "C:\cnes" "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=249203_b291ca3e0c8548b5a51d5a5f50063037"

REM Extract the contents of the Firebird installer zip file
Powershell Expand-Archive -Path .\InstaladorFirebird-155.zip -DestinationPath .\cnes\temp
Powershell Expand-Archive -Path .\SCNES4540-COMPLETA.zip -DestinationPath .\cnes\temp

REM Rename the Firebird installer
cd .\temp
ren Firebird-1.5.5.4926-3-win32.exe setup.exe

REM Start the installation
start "C:\cnes\temp\setup.exe"
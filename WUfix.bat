REM Set Windows Module Installer service (TrustedInstaller) to start automatically
SC config trustedinstaller start=auto

REM Stop Windows Update service and Background Intelligent Transfer Service
net stop wuauserv
net stop bits

REM Change directory to the Windows directory
cd %windir%

REM Rename SoftwareDistribution folder to SoftwareDistribution.old
Ren SoftwareDistribution SoftwareDistribution.old

REM Use DISM tool to scan and repair Windows image
dism /online /cleanup-image /restorehealth

REM Run System File Checker to scan and repair corrupted system files
sfc /scannow

REM Restart the computer
shutdown /r /t 0
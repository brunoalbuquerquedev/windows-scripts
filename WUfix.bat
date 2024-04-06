SC config trustedinstaller start=auto
REM Set Windows Module Installer service (TrustedInstaller) to start automatically

net stop wuauserv
net stop bits
REM Stop Windows Update service and Background Intelligent Transfer Service

cd %windir%
REM Change directory to the Windows directory

Ren SoftwareDistribution SoftwareDistribution.old
REM Rename SoftwareDistribution folder to SoftwareDistribution.old

dism /online /cleanup-image /restorehealth
REM Use DISM tool to scan and repair Windows image

sfc /scannow
REM Run System File Checker to scan and repair corrupted system files

shutdown /r /t 0
REM Restart the computer
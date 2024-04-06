@echo off
REM Disable the echoing of commands in the batch script

echo Windows update error fix script 
REM Display a message indicating the purpose of the script
REM This script can bge used to fix the errors with code 0x80244011, 0x800f0954

net stop wuauserv
REM Stop the Windows Update service to prevent updates during script execution

del /q %windir%\SoftwareDistribution\DataStore\*.*
REM Delete all files within the SoftwareDistribution\DataStore directory
REM This directory stores temporary update files

mkdir %windir%\SoftwareDistribution\DataStore
REM Recreate the SoftwareDistribution\DataStore directory

reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v WUServer /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v WUStatusServer /f
REM Delete registry keys related to Windows Update settings to resolve configuration issues

net start wuauserv
REM Start the Windows Update service to resume update functionality

del /q C:\Windows\Logs\CBS\*.*
REM Delete all files within the CBS (Component-Based Servicing) logs directory
REM These logs often contain information about system component installations and can sometimes become corrupted

dism.exe /online /enable-feature /featurename:NetFX3 /source:C:\
REM Enable the .NET Framework 3.5 feature using DISM, specifying the source location as the root of the C drive

powershell -command "Add-WindowsCapability –Online -Name NetFx3~ –Source D:\sources\sxs"
REM Add the .NET Framework 3.5 feature using PowerShell, specifying the source location as D:\sources\sxs

sfc /scannow
REM Run the System File Checker utility to scan and repair corrupted system files

pause
REM Pause script execution to allow user review before proceeding

cls
REM Clear the console screen for better interface

if %errorlevel% equ 0 (
    echo The script is completed, no errors found
) else (
    echo An error was found
)
REM Check the error level returned by previous commands and display appropriate message

echo The computer will now be restarted
pause
REM Inform the user about the impending system restart

shutdown /r /t 3
REM Initiate a system restart after a 3-second delay
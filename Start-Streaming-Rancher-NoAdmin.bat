@echo off
REM =============================================================================
REM Thinklet Streaming Environment - Start (Rancher Desktop - NO ADMIN)
REM 
REM This batch file starts all required services for the streaming environment
REM WITHOUT requesting administrator privileges.
REM 
REM It assumes that the necessary firewall ports have already been opened
REM by an administrator.
REM 
REM DOUBLE-CLICK THIS FILE TO START
REM =============================================================================

REM Change to script directory
cd /d "%~dp0"

title Thinklet Streaming Environment Startup (Rancher Desktop - NO ADMIN)

echo.
echo ====================================================================
echo  Thinklet Streaming Environment - Startup (Rancher Desktop - NO ADMIN)
echo ====================================================================
echo.
echo IMPORTANT: Make sure firewall ports have been opened by an admin.
echo.

REM Execute the PowerShell script
PowerShell.exe -ExecutionPolicy Bypass -File "%~dp0start-streaming-rancher-noadmin.ps1"

REM Check if the script executed successfully
if %errorLevel% == 0 (
    echo.
    echo ============================================================
    echo  All Services Started Successfully!
    echo ============================================================
    echo.
    echo You can now:
    echo   - Connect Android devices to start streaming
    echo   - Open web browser to view the streams
    echo.
) else (
    echo.
    echo ============================================================
    echo  Startup Failed - Please Check Error Messages Above
    echo ============================================================
    echo.
)

REM Keep the window open
echo Press any key to close this window...
pause >nul



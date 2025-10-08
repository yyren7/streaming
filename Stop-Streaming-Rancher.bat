@echo off
REM =============================================================================
REM Thinklet Streaming Environment - Stop Script (Rancher Desktop)
REM =============================================================================

echo ============================================================
echo  Stopping Thinklet Streaming Environment
echo ============================================================

REM Stop Node.js server
echo.
echo --> Stopping Node.js server (port 8000)...
taskkill /F /IM node.exe >nul 2>&1
if %errorLevel% == 0 (
    echo      - Node.js server stopped
) else (
    echo      - No Node.js server was running
)

REM Stop Docker container
echo.
echo --> Stopping SRS Docker container...
docker stop srs-server >nul 2>&1
if %errorLevel% == 0 (
    echo      - SRS container stopped
    docker rm srs-server >nul 2>&1
    echo      - SRS container removed
) else (
    echo      - SRS container not found or already stopped
)

echo.
echo ============================================================
echo  All services stopped
echo ============================================================
echo.
pause
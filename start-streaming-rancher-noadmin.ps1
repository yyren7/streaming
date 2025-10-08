# =============================================================================
# Thinklet Streaming Environment Startup Script (Rancher Desktop Version - NO ADMIN)
#
# This script is optimized for environments using Rancher Desktop to manage Docker
# It does NOT require administrator privileges and assumes the firewall has been
# pre-configured by an administrator.
#
# Main functions:
# 1. Start Docker services (SRS server)
# 2. Start Node.js WebSocket server
# 3. Verify all services are running correctly
# =============================================================================

# Set script directory as current location
$scriptDir = $PSScriptRoot
if (-not $scriptDir) {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
}
Set-Location $scriptDir

Write-Host "=== Starting Streaming Environment (Rancher Desktop - NO ADMIN) ===" -ForegroundColor Cyan
Write-Host "IMPORTANT: This script assumes firewall ports (1935, 8080, 1985, 8000) have been opened by an administrator." -ForegroundColor Yellow
Write-Host ""

# 1. Check Docker Availability
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "--> Step 1: Checking Docker Environment" -ForegroundColor Yellow

Write-Host "    - Checking if Docker is available..."
try {
    $dockerVersion = docker --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "      [OK] Docker is ready: $dockerVersion" -ForegroundColor Green
    } else {
        throw "Docker command execution failed"
    }
} catch {
    Write-Host "      [FAIL] Docker is not available!" -ForegroundColor Red
    Write-Host "      Please ensure Rancher Desktop is running and Docker is enabled." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# 2. Start Docker Container (SRS Server)
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "--> Step 2: Starting SRS Streaming Server" -ForegroundColor Yellow

Write-Host "    - Checking and cleaning existing containers..."
$existingContainer = docker ps -a --filter "name=srs-server" --format "{{.Names}}" 2>$null
if ($existingContainer -match "srs-server") {
    Write-Host "      [INFO] Found existing srs-server container, removing..." -ForegroundColor Yellow
    docker stop srs-server 2>$null | Out-Null
    docker rm srs-server 2>$null | Out-Null
    Write-Host "      [OK] Old container removed" -ForegroundColor Green
}

Write-Host "    - Starting SRS container..."
try {
    $configPath = Join-Path $scriptDir "config"
    Set-Location $configPath
    
    docker compose up -d 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Docker compose failed to start"
    }
    
    Write-Host "      [OK] SRS container started" -ForegroundColor Green
    
    # Wait for SRS service to be ready
    Write-Host "      [INFO] Waiting for SRS service to initialize..." -ForegroundColor Cyan
    $srsReady = $false
    $maxAttempts = 30
    
    for ($attempt = 1; $attempt -le $maxAttempts; $attempt++) {
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:1985/api/v1/versions" -TimeoutSec 2 -ErrorAction Stop
            if ($response.StatusCode -eq 200) {
                Write-Host "      [OK] SRS service is ready!" -ForegroundColor Green
                $srsReady = $true
                break
            }
        } catch {
            Start-Sleep -Seconds 1
            if ($attempt % 5 -eq 0) {
                Write-Host "      [INFO] Still waiting for SRS to initialize... ($attempt/$maxAttempts)" -ForegroundColor Yellow
            }
        }
    }
    
    if (-not $srsReady) {
        throw "SRS service not ready after $maxAttempts seconds"
    }
    
    Set-Location $scriptDir
} catch {
    Write-Host "      [FAIL] Failed to start SRS service!" -ForegroundColor Red
    Write-Host "      Error: $_" -ForegroundColor Yellow
    Set-Location $scriptDir
    Read-Host "Press Enter to exit"
    exit 1
}

# 3. Start Node.js Server
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "--> Step 3: Starting Node.js WebSocket Server" -ForegroundColor Yellow

Write-Host "    - Checking if port 8000 is in use..."
$port8000Connection = Get-NetTCPConnection -LocalPort 8000 -ErrorAction SilentlyContinue
if ($port8000Connection) {
    # Get unique process IDs that are using the port
    $pids = $port8000Connection.OwningProcess | Select-Object -Unique
    
    foreach ($procId in $pids) {
        $existingProcess = Get-Process -Id $procId -ErrorAction SilentlyContinue
        if ($existingProcess) {
            Write-Host "      [INFO] Port 8000 is occupied by: $($existingProcess.ProcessName) (PID: $($existingProcess.Id))" -ForegroundColor Yellow
            
            # Do not attempt to kill System (PID 4) or System Idle Process (PID 0)
            if ($existingProcess.Id -eq 0 -or $existingProcess.Id -eq 4) {
                Write-Host "      [WARN] Port is temporarily held by a system process. Waiting for OS to release it..." -ForegroundColor Yellow
                Start-Sleep -Seconds 3 
            } else {
                Write-Host "      [INFO] Stopping the process..." -ForegroundColor Yellow
                try {
                    Stop-Process -Id $existingProcess.Id -Force -ErrorAction Stop
                    Start-Sleep -Seconds 2
                    Write-Host "      [OK] Old process stopped" -ForegroundColor Green
                } catch {
                    Write-Host "      [FAIL] Failed to stop process with PID $($existingProcess.Id). It may require administrator rights." -ForegroundColor Red
                }
            }
        }
    }
}

Write-Host "    - Starting Node.js server..."
try {
    # Check if Node.js is installed
    $nodeExe = Get-Command node -ErrorAction SilentlyContinue
    if (-not $nodeExe) {
        throw "Node.js not found, please install Node.js first"
    }
    
    # Check if server script exists
    $serverScript = Join-Path $scriptDir "src\simple-http-server.js"
    if (-not (Test-Path $serverScript)) {
        throw "Server script not found: $serverScript"
    }
    
    # Start Node.js server in background
    Start-Process -FilePath "node.exe" -ArgumentList "`"$serverScript`"" -WorkingDirectory $scriptDir -WindowStyle Hidden
    
    Write-Host "      [OK] Node.js server started" -ForegroundColor Green
    Write-Host "      [INFO] Waiting for server to initialize..." -ForegroundColor Cyan
    Start-Sleep -Seconds 5
} catch {
    Write-Host "      [FAIL] Failed to start Node.js server!" -ForegroundColor Red
    Write-Host "      Error: $_" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# 4. Verify Service Connectivity
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "--> Step 4: Verifying Service Connectivity" -ForegroundColor Yellow

$testPorts = @{
    "1935" = "RTMP (Video Ingest)";
    "8080" = "HTTP-FLV (Video Playback)";
    "1985" = "SRS API";
    "8000" = "WebSocket Server";
}

$allPortsConnected = $true
foreach ($port in $testPorts.Keys) {
    $portName = $testPorts[$port]
    $portConnected = $false
    
    # Wait up to 10 seconds for port to become available
    foreach ($attempt in 1..10) {
        try {
            $socket = New-Object System.Net.Sockets.TcpClient
            $socket.Connect("localhost", $port)
            if ($socket.Connected) {
                Write-Host "      [OK] Port $port ($portName) is connected" -ForegroundColor Green
                $socket.Close()
                $portConnected = $true
                break
            }
        } catch {
            Start-Sleep -Seconds 1
        } finally {
            if ($socket) { $socket.Dispose() }
        }
    }
    
    if (-not $portConnected) {
        Write-Host "      [FAIL] Timeout: Port $port ($portName) not connectable after 10 seconds" -ForegroundColor Red
        $allPortsConnected = $false
    }
}

# 5. Final Summary
# -----------------------------------------------------------------------------
Write-Host ""
if ($allPortsConnected) {
    # Get Windows IP address
    $windowsIp = $null
    try {
        $windowsIp = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { 
            $_.IPAddress -like '192.168.*' -or $_.IPAddress -like '10.*' -or $_.IPAddress -like '172.*' 
        } | Select-Object -First 1).IPAddress
    } catch {}
    
    if (-not $windowsIp) {
        $windowsIp = "localhost"
    }
    
    Write-Host "==================== SUCCESS ====================" -ForegroundColor Green
    Write-Host "All services are up and running!"
    Write-Host "You can now connect from your devices."
    Write-Host ""
    Write-Host "  - Windows Host IP: $windowsIp"
    Write-Host "  - WebSocket Server: ws://$windowsIp:8000"
    Write-Host "  - RTMP Stream URL: rtmp://$windowsIp:1935/thinklet.squid.run/STREAM_KEY"
    Write-Host "  - Web Interface/Player: http://$windowsIp:8080"
    Write-Host "=================================================" -ForegroundColor Green
} else {
    Write-Host "==================== FAILED ====================" -ForegroundColor Red
    Write-Host "One or more services failed to start or are not accessible."
    Write-Host "Please review the error messages above."
    Write-Host "=================================================" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit"

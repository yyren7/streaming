[English (EN)](./README.md) | [简体中文 (zh-CN)](./README.zh-CN.md) | [日本語 (ja-JP)](./README.ja-JP.md)

# Thinklet Streaming Documentation Navigation

Welcome to the Thinklet Streaming System! This document will help you quickly find the information you need.

## 🚀 Quick Start

If you are a first-time user, please read in the following order:

1.  **[QUICK-START.md](./docs/QUICK-START.md)** ⭐ Most Recommended
    *   Start the streaming environment in 3 steps
    *   Includes a checklist of environment requirements
    *   Use `Start-Streaming-Rancher.bat` for one-click startup

2.  **[README-streaming.md](./docs/README-streaming.md)**
    *   Detailed technical documentation
    *   Complete feature descriptions
    *   Advanced configuration options

## 📚 Document Index

### Basic Configuration

*   **[QUICK-START.md](./docs/QUICK-START.md)**
    Quick start guide, recommended for all users to read first.

*   **[README-streaming.md](./docs/README-streaming.md)**
    Complete documentation for the streaming system, including:
    *   Rancher Desktop configuration steps
    *   Multi-device streaming support
    *   Detailed SRS server configuration
    *   Troubleshooting guide

### Device Configuration

*   **[ANDROID-CONNECTION-GUIDE.md](./docs/ANDROID-CONNECTION-GUIDE.md)**
    Android device connection configuration guide, including:
    *   RTMP URL configuration
    *   Network diagnostic steps
    *   Solutions for common connection issues

### File Transfer

*   **[FILE-TRANSFER-README.md](./docs/FILE-TRANSFER-README.md)**
    User guide for the automatic video file transfer feature, including:
    *   Extremely low-power file transfer solution
    *   Automatic download and MD5 checksum verification
    *   Web interface operation instructions

*   **[file-transfer-design.md](./docs/file-transfer-design.md)**
    Technical design document for the file transfer feature (for developer reference).

## 📂 Folder Structure

```
streaming/
├── 📄 README.md                      # Main navigation document (this document)
├── 📄 package.json                   # Node.js project configuration
├── 📄 package-lock.json              # Dependency lock file
│
├── 🚀 Start-Streaming-Rancher.bat    # One-click startup script ⭐
├── 🔧 start-streaming-rancher.ps1    # Core PowerShell script
│
├── 📂 docs/                          # Documentation directory
│   ├── QUICK-START.md               # Quick start guide ⭐
│   ├── README-streaming.md          # Detailed technical documentation
│   ├── ANDROID-CONNECTION-GUIDE.md  # Android configuration guide
│   ├── FILE-TRANSFER-README.md      # File transfer feature documentation
│   └── file-transfer-design.md      # Technical design document
│
├── 📂 src/                           # Source code directory
│   ├── simple-http-server.js        # HTTP/WebSocket server
│   ├── file-transfer-service.js     # File transfer service
│   ├── i18n.js                      # Internationalization
│   └── main.js                      # Frontend main script
│
├── 📂 public/                        # Web assets directory
│   ├── index.html                   # Web interface
│   └── style.css                    # Stylesheet
│
├── 📂 config/                        # Configuration files directory
│   ├── docker-compose.yml           # Docker Compose configuration
│   ├── srs.conf                     # SRS server configuration
│   └── devices.json                 # Device information storage (auto-generated)
│
├── 📂 video/                         # Video file storage directory
│   └── {deviceId}/                  # Videos grouped by device
│
└── 📂 node_modules/                  # Node.js dependencies (auto-generated)
```

## 🔧 Core Scripts

### Windows Startup Scripts

*   **`Start-Streaming-Rancher.bat`** ⭐ Recommended
    *   Automatically requests administrator privileges
    *   One-click startup for all services (SRS, Node.js)
    *   Automatic network and firewall configuration
    *   Cleans up old processes before starting

*   **`start-streaming-rancher.ps1`**
    *   Core PowerShell script
    *   Automatically called by the `.bat` file
    *   Handles startup, checks, and network configuration for all services

## ⚙️ Environment Requirements

### Required Software

1.  **Rancher Desktop** (Recommended) or **Docker Desktop**
    *   Download at: https://rancherdesktop.io/
    *   ⚠️ Important: Do not manually install Docker inside WSL

2.  **WSL 2** (Windows Subsystem for Linux 2)
    *   Requires installation of Ubuntu or another Linux distribution
    *   Check version with `wsl -l -v`

3.  **Node.js** (v16 or higher)
    *   Download at: https://nodejs.org/

### Rancher Desktop Configuration (Crucial Steps)

1.  Open Rancher Desktop
2.  Go to **Preferences → WSL**
3.  ✅ Check your WSL distribution (e.g., `Ubuntu`)
4.  ❌ Do not check `rancher-desktop` or `rancher-desktop-data`
5.  Save and wait for it to restart

### Verify Configuration

In your Ubuntu WSL terminal, run:
```bash
docker --version
```

You should see:
```
Docker version 28.3.3-rd, build 309deef
```

Note the `-rd` suffix, which indicates it's using the Docker provided by Rancher Desktop.

## 🎯 Usage Flow

### 1. First-time Installation

```bash
# In the streaming directory
npm install
```

### 2. Start Services

Double-click `Start-Streaming-Rancher.bat` and click "Yes" to grant administrator privileges.

### 3. Configure Android App

Configure in `app/src/main/java/ai/fd/thinklet/app/squid/run/DefaultConfig.kt`:

```kotlin
const val DEFAULT_STREAM_URL = "rtmp://YOUR-PC-IP:1935/thinklet.squid.run"
const val DEFAULT_STREAM_KEY = "device1"
```

### 4. Start Streaming

Click "Start Streaming" in the Android app, then visit in your browser:
```
http://YOUR-PC-IP:8000
```

## 🔍 Quick Troubleshooting Reference

| Issue | Solution |
|---|---|
| `docker` command not found | Check Rancher Desktop WSL integration settings |
| `rancher-desktop` error message | Use `Start-Streaming-Rancher.bat` to start |
| Android cannot connect | Ensure PC and phone are on the same Wi-Fi network |
| Cannot connect after restart | Rerun `Start-Streaming-Rancher.bat` |

For detailed troubleshooting steps, please see the "Troubleshooting" section in each document.

## 📊 Features

### Streaming Features
- 🎥 Low-latency live streaming (1-3 seconds)
- 📱 Simultaneous streaming from multiple devices
- 🎬 Real-time video preview
- 📊 Stream status monitoring

### File Transfer Features
- 🔋 Extremely low power consumption (Android CPU < 5%)
- 🔄 Resumable transfers
- 🔐 MD5 integrity check
- 📊 Real-time progress display
- ⚙️ Automatic retry mechanism

## 🆘 Getting Help

If you encounter issues:

1.  Check the troubleshooting section in [QUICK-START.md](./docs/QUICK-START.md)
2.  Check the detailed troubleshooting in [README-streaming.md](./docs/README-streaming.md)
3.  Check the log output in the terminal and browser console
4.  Confirm all environment requirements are met

## 📝 Document Update Log

### 2025-10-06
- ✅ Reorganized folder structure (docs/, src/, public/, config/)
- ✅ Removed outdated manual configuration documents
- ✅ Emphasized Rancher Desktop as the standard Docker environment
- ✅ Updated all documents to reflect the automated startup script
- ✅ Added detailed environment configuration verification steps
- ✅ Updated all path references and dependencies

---

**Get Started**: Just read [QUICK-START.md](./docs/QUICK-START.md)! 🚀


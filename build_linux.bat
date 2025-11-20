@echo off
REM Flutter Linux Cross-Compilation Script for Windows
REM Requires Docker Desktop to be installed and running

setlocal enabledelayedexpansion

echo [INFO] Flutter Linux Cross-Compilation Script
echo [INFO] ========================================

REM Check if Docker is available
docker --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not installed or not running
    echo [ERROR] Please install Docker Desktop and make sure it's running
    pause
    exit /b 1
)

REM Check if we're in the correct directory
if not exist "pubspec.yaml" (
    echo [ERROR] pubspec.yaml not found. Please run this script from the Flutter project root.
    pause
    exit /b 1
)

echo [INFO] Starting Flutter Linux cross-compilation...
echo.

REM Build the Docker image
echo [INFO] Building Docker image for cross-compilation...
docker build -f Dockerfile.linux -t flutter-linux-crosscompile .
if errorlevel 1 (
    echo [ERROR] Failed to build Docker image
    pause
    exit /b 1
)

REM Create output directory
set OUTPUT_DIR=build\output
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

REM Extract the built applications
echo [INFO] Extracting built applications...
docker run --rm -v "%cd%\%OUTPUT_DIR%":/output flutter-linux-crosscompile cp -r /output/* /output/
if errorlevel 1 (
    echo [ERROR] Failed to extract applications
    pause
    exit /b 1
)

REM Create distribution packages
echo [INFO] Creating distribution packages...
cd "%OUTPUT_DIR%"

REM Create tar archives for easy distribution
tar -czf "downtimer-linux-x64.tar.gz" -C linux-x64 .
tar -czf "downtimer-linux-arm64.tar.gz" -C linux-arm64 .

cd ..

echo.
echo [SUCCESS] Build completed successfully!
echo [INFO] Output files created in: %OUTPUT_DIR%\
echo [INFO] Available distributions:
dir /b "%OUTPUT_DIR%\*.tar.gz"

echo.
echo [WARNING] Note: The compiled binaries need to be tested on actual Linux systems
echo [WARNING]        The ARM64 version requires an ARM64 Linux system (like Raspberry Pi 4)
echo.

pause
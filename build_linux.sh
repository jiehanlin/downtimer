#!/bin/bash

# Flutter Linux Cross-Compilation Script
# Supports building for x64 and ARM64 architectures

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed or not in PATH"
    exit 1
fi

# Check if we're in the correct directory
if [ ! -f "pubspec.yaml" ]; then
    print_error "pubspec.yaml not found. Please run this script from the Flutter project root."
    exit 1
fi

print_status "Starting Flutter Linux cross-compilation..."

# Build the Docker image
print_status "Building Docker image for cross-compilation..."
docker build -f Dockerfile.linux -t flutter-linux-crosscompile .

# Create output directory
OUTPUT_DIR="build/output"
mkdir -p "$OUTPUT_DIR"

# Extract the built applications
print_status "Extracting built applications..."
docker run --rm -v "$(pwd)/$OUTPUT_DIR":/output flutter-linux-crosscompile cp -r /output/* /output/

# Create distribution packages
print_status "Creating distribution packages..."
cd "$OUTPUT_DIR"

# Create tar archives for easy distribution
tar -czf "downtimer-linux-x64.tar.gz" -C linux-x64 .
tar -czf "downtimer-linux-arm64.tar.gz" -C linux-arm64 .

# Create a README for the distributions
cat > README.md << 'EOF'
# DownTimer Linux Distribution

## Files

- `downtimer-linux-x64.tar.gz`: For 64-bit Intel/AMD systems
- `downtimer-linux-arm64.tar.gz`: For 64-bit ARM systems (Raspberry Pi 4, etc.)

## Installation

### Extract and run:
```bash
# For x64 systems
tar -xzf downtimer-linux-x64.tar.gz
./downtimer

# For ARM64 systems
tar -xzf downtimer-linux-arm64.tar.gz
./downtimer
```

### System-wide installation (optional):
```bash
# Extract to /opt
sudo tar -xzf downtimer-linux-x64.tar.gz -C /opt
sudo ln -s /opt/downtimer /usr/local/bin/downtimer
```

## Dependencies

The application bundles its own dependencies, but you may need:
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install libgtk-3-0 libxss1 libasound2

# Fedora
sudo dnf install gtk3 libXScrnSaver alsa-lib

# Arch Linux
sudo pacman -S gtk3 libxss alsa-lib
```

## Running

Simply run the executable:
```bash
./downtimer
```

The application will start with a dark-themed countdown timer interface.
EOF

cd ..

print_success "Build completed successfully!"
print_status "Output files created in: $OUTPUT_DIR/"
print_status "Available distributions:"
ls -la "$OUTPUT_DIR"/*.tar.gz

print_status "To test the builds:"
echo "  docker run --rm -it flutter-linux-crosscompile /output/verify.sh"

print_warning "Note: The compiled binaries need to be tested on actual Linux systems"
print_warning "      The ARM64 version requires an ARM64 Linux system (like Raspberry Pi 4)"
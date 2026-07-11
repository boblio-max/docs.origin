#!/bin/sh
set -e

# Origin CLI Installer
# https://docs-origin.onrender.com/cliinstall.sh

REPO="boblio-max/origindevtools"
BINARY_NAME="origin"
VERSION="latest"

# Detect OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     OS="linux";;
    Darwin*)    OS="macos";;
    MINGW*|MSYS*|CYGWIN*)  OS="windows";;
    *)          echo "Error: Unsupported OS: ${OS}"; exit 1;;
esac

# Detect Architecture
ARCH="$(uname -m)"
case "${ARCH}" in
    x86_64|amd64)   ARCH="x86_64";;
    arm64|aarch64)   ARCH="aarch64";;
    armv7l|armhf)    ARCH="armv7";;
    *)               echo "Error: Unsupported architecture: ${ARCH}"; exit 1;;
esac

echo ""
echo "Origin CLI Installer"
echo "Detected: ${OS} ${ARCH}"
echo ""

# Set download URL based on OS
if [ "${OS}" = "windows" ]; then
    DOWNLOAD_URL="https://github.com/${REPO}/releases/latest/download/${BINARY_NAME}.exe"
    INSTALL_PATH="./${BINARY_NAME}.exe"
else
    DOWNLOAD_URL="https://github.com/${REPO}/releases/latest/download/${BINARY_NAME}"
    INSTALL_PATH="/usr/local/bin/${BINARY_NAME}"
fi

echo "Downloading from: ${DOWNLOAD_URL}"

# Download binary
if [ "${OS}" = "windows" ]; then
    # Windows - download to current directory
    curl -fsSL "${DOWNLOAD_URL}" -o "${BINARY_NAME}.exe"
    echo ""
    echo "Downloaded ${BINARY_NAME}.exe to current directory"
    echo "Move ${BINARY_NAME}.exe to a directory in your PATH to use it globally"
else
    # Linux/macOS - install to /usr/local/bin
    echo "Installing to ${INSTALL_PATH}..."
    sudo curl -fsSL "${DOWNLOAD_URL}" -o "${INSTALL_PATH}"
    sudo chmod +x "${INSTALL_PATH}"
    echo ""
    echo "Installed ${BINARY_NAME} to ${INSTALL_PATH}"
fi

echo ""
echo "Installation complete!"
echo ""
echo "Get started:"
echo "  ${BINARY_NAME} help        # Show available commands"
echo "  ${BINARY_NAME}             # Start interactive REPL"
echo "  ${BINARY_NAME} myfile.or   # Run an Origin file"
echo ""
echo "Documentation:"
echo "  https://docs-origin.onrender.com"
echo ""

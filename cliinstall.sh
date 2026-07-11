#!/bin/bash
set -e

# Origin CLI Installer
# https://docs-origin.onrender.com/cliinstall.sh

REPO="boblio-max/origindevtools"
BINARY_NAME="origin"
VERSION="latest"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${CYAN}  ▄██████▄     ▄████████  ▄█    ▄██████▄    ▄█   ███▄▄▄▄${NC}"
echo -e "${CYAN} ███    ███   ███    ███ ███  ███      ███ ███  ███▀▀▀██▄${NC}"
echo -e "${CYAN} ███    ███   ███    ███ ███▌ ███      █▀  ███▌ ███   ███${NC}"
echo -e "${CYAN} ███    ███  ▄███▄▄▄▄██▀ ███▌ ███          ███▌ ███   ███${NC}"
echo -e "${CYAN} ███    ███ ▀▀███▀▀▀▀▀   ███▌ ███  ▀██████ ███▌ ███   ███${NC}"
echo -e "${CYAN} ███    ███ ▀███████████ ███  ███      ███ ███  ███   ███${NC}"
echo -e "${CYAN} ███    ███   ███    ███ ███  ███      ███ ███  ███   ███${NC}"
echo -e "${CYAN}  ▀██████▀    ▀█     █▀   █▀   ▀████████▀  █▀    ▀█   █▀${NC}"
echo ""
echo -e "${GREEN}Origin CLI Installer${NC}"
echo ""

# Detect OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     OS="linux";;
    Darwin*)    OS="macos";;
    MINGW*|MSYS*|CYGWIN*)  OS="windows";;
    *)          echo -e "${RED}Error: Unsupported OS: ${OS}${NC}"; exit 1;;
esac

# Detect Architecture
ARCH="$(uname -m)"
case "${ARCH}" in
    x86_64|amd64)   ARCH="x86_64";;
    arm64|aarch64)   ARCH="aarch64";;
    armv7l|armhf)    ARCH="armv7";;
    *)               echo -e "${RED}Error: Unsupported architecture: ${ARCH}${NC}"; exit 1;;
esac

echo -e "${YELLOW}Detected: ${OS} ${ARCH}${NC}"

# Set download URL based on OS
if [ "${OS}" = "windows" ]; then
    DOWNLOAD_URL="https://github.com/${REPO}/releases/latest/download/${BINARY_NAME}.exe"
    INSTALL_PATH="./${BINARY_NAME}.exe"
else
    DOWNLOAD_URL="https://github.com/${REPO}/releases/latest/download/${BINARY_NAME}"
    INSTALL_PATH="/usr/local/bin/${BINARY_NAME}"
fi

echo -e "${YELLOW}Downloading from: ${DOWNLOAD_URL}${NC}"

# Download binary
if [ "${OS}" = "windows" ]; then
    # Windows - download to current directory
    curl -fsSL "${DOWNLOAD_URL}" -o "${BINARY_NAME}.exe"
    echo ""
    echo -e "${GREEN}Downloaded ${BINARY_NAME}.exe to current directory${NC}"
    echo -e "${YELLOW}Move ${BINARY_NAME}.exe to a directory in your PATH to use it globally${NC}"
    echo -e "${YELLOW}Example: move ${BINARY_NAME}.exe to C:\\Windows${NC}"
else
    # Linux/macOS - install to /usr/local/bin
    echo -e "${YELLOW}Installing to ${INSTALL_PATH}...${NC}"
    sudo curl -fsSL "${DOWNLOAD_URL}" -o "${INSTALL_PATH}"
    sudo chmod +x "${INSTALL_PATH}"
    echo ""
    echo -e "${GREEN}Installed ${BINARY_NAME} to ${INSTALL_PATH}${NC}"
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo -e "${CYAN}Get started:${NC}"
echo -e "  ${BINARY_NAME} help        # Show available commands"
echo -e "  ${BINARY_NAME}             # Start interactive REPL"
echo -e "  ${BINARY_NAME} myfile.or   # Run an Origin file"
echo ""
echo -e "${CYAN}Documentation:${NC}"
echo -e "  https://docs-origin.onrender.com"
echo ""

#!/bin/sh
set -e

# Origin CLI Installer
# https://docs-origin.onrender.com/cliinstall.sh

REPO="boblio-max/origindevtools"
INSTALL_DIR="/usr/local/bin"
BINARY_NAME="origin"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

if ! command -v curl > /dev/null 2>&1; then
    echo -e "${RED}Error: curl is required but not installed.${NC}"
    exit 1
fi

echo -e "${GREEN}Installing Origin CLI...${NC}"

OS="$(uname -s)"
case "${OS}" in
    Linux*)                  OS="linux";;
    Darwin*)                 OS="macos";;
    MINGW*|MSYS*|CYGWIN*)   OS="windows";;
    *)                       echo -e "${RED}Unsupported OS: ${OS}${NC}"; exit 1;;
esac

ARCH="$(uname -m)"
case "${ARCH}" in
    x86_64|amd64)    ARCH="x86_64";;
    arm64|aarch64)   ARCH="aarch64";;
    armv7l|armhf)    ARCH="armv7";;
    *)               echo -e "${RED}Unsupported architecture: ${ARCH}${NC}"; exit 1;;
esac

case "${OS}-${ARCH}" in
    linux-x86_64)    ASSET="origin-linux-x86_64";;
    linux-aarch64)   ASSET="origin-linux-aarch64";;
    linux-armv7)     ASSET="origin-linux-armv7";;
    macos-x86_64)    ASSET="origin-macos-x86_64";;
    macos-aarch64)   ASSET="origin-macos-aarch64";;
    windows-x86_64)  ASSET="origin-windows-x86_64.exe";;
    windows-aarch64) ASSET="origin-windows-aarch64.exe";;
    *)
        echo -e "${RED}No prebuilt binary available for ${OS}-${ARCH}${NC}"
        exit 1
        ;;
esac

if [ "${OS}" = "windows" ]; then
    BINARY_NAME="origin.exe"
fi

echo -e "${YELLOW}Detected: ${OS} ${ARCH}${NC}"

VERSION=$(curl -fsSL -o /dev/null -w '%{url_effective}' "https://github.com/${REPO}/releases/latest" | sed 's|.*/||')
if [ -z "${VERSION}" ]; then
    echo -e "${RED}Failed to resolve latest version${NC}"
    exit 1
fi

echo -e "${YELLOW}Version: ${VERSION}${NC}"

BASE_URL="https://github.com/${REPO}/releases/download/${VERSION}"
CHECKSUMS_URL="${BASE_URL}/checksums.txt"
DOWNLOAD_URL="${BASE_URL}/${ASSET}"

TMPDIR="${TMPDIR:-/tmp}"
TMPFILE="$(mktemp "${TMPDIR}/origin.XXXXXX")"
TMPCHECKSUMS="$(mktemp "${TMPDIR}/origin-checksums.XXXXXX")"
trap 'rm -f "${TMPFILE}" "${TMPCHECKSUMS}"' EXIT

echo -e "${YELLOW}Downloading checksums...${NC}"
if ! curl -fsSL "${CHECKSUMS_URL}" -o "${TMPCHECKSUMS}"; then
    echo -e "${RED}Failed to download checksums${NC}"
    exit 1
fi

echo -e "${YELLOW}Downloading ${ASSET}...${NC}"
if ! curl -fsSL "${DOWNLOAD_URL}" -o "${TMPFILE}"; then
    echo -e "${RED}Failed to download binary${NC}"
    exit 1
fi

echo -e "${YELLOW}Verifying checksum...${NC}"
EXPECTED_HASH=$(grep "${ASSET}" "${TMPCHECKSUMS}" | awk '{print $1}')
if [ -z "${EXPECTED_HASH}" ]; then
    echo -e "${RED}No checksum found for ${ASSET}${NC}"
    exit 1
fi

if command -v sha256sum > /dev/null 2>&1; then
    ACTUAL_HASH=$(sha256sum "${TMPFILE}" | awk '{print $1}')
elif command -v shasum > /dev/null 2>&1; then
    ACTUAL_HASH=$(shasum -a 256 "${TMPFILE}" | awk '{print $1}')
else
    echo -e "${RED}No sha256sum or shasum found, cannot verify checksum${NC}"
    exit 1
fi

if [ "${EXPECTED_HASH}" != "${ACTUAL_HASH}" ]; then
    echo -e "${RED}Checksum mismatch!${NC}"
    echo -e "${RED}  Expected: ${EXPECTED_HASH}${NC}"
    echo -e "${RED}  Actual:   ${ACTUAL_HASH}${NC}"
    exit 1
fi

echo -e "${GREEN}Checksum verified.${NC}"

if [ "${OS}" = "windows" ]; then
    if [ -d "${INSTALL_DIR}" ] && [ -w "${INSTALL_DIR}" ]; then
        cp "${TMPFILE}" "${INSTALL_DIR}/${BINARY_NAME}"
        echo -e "${GREEN}Installed ${BINARY_NAME} to ${INSTALL_DIR}${NC}"
    else
        cp "${TMPFILE}" "./${BINARY_NAME}"
        echo -e "${GREEN}Downloaded ${BINARY_NAME} to current directory${NC}"
        echo -e "${YELLOW}Move ${BINARY_NAME} to a directory in your PATH to use it globally${NC}"
    fi
else
    if [ -w "${INSTALL_DIR}" ]; then
        cp "${TMPFILE}" "${INSTALL_DIR}/${BINARY_NAME}"
        chmod +x "${INSTALL_DIR}/${BINARY_NAME}"
    else
        sudo cp "${TMPFILE}" "${INSTALL_DIR}/${BINARY_NAME}"
        sudo chmod +x "${INSTALL_DIR}/${BINARY_NAME}"
    fi
    echo -e "${GREEN}Installed ${BINARY_NAME} to ${INSTALL_DIR}/${BINARY_NAME}${NC}"
fi

echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Get started:"
echo "  ${BINARY_NAME} help        # Show available commands"
echo "  ${BINARY_NAME}             # Start interactive REPL"
echo "  ${BINARY_NAME} myfile.or   # Run an Origin file"
echo ""
echo "Documentation:"
echo "  https://docs-origin.onrender.com"
echo ""

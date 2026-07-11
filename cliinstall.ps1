# Origin CLI Installer for Windows
# https://docs-origin.onrender.com/cliinstall.ps1

$REPO = "boblio-max/origindevtools"
$BINARY_NAME = "origin"

Write-Host ""
Write-Host "  ▄██████▄     ▄████████  ▄█    ▄██████▄    ▄█   ███▄▄▄▄" -ForegroundColor Cyan
Write-Host " ███    ███   ███    ███ ███  ███      ███ ███  ███▀▀▀██▄" -ForegroundColor Cyan
Write-Host " ███    ███   ███    ███ ███▌ ███      █▀  ███▌ ███   ███" -ForegroundColor Cyan
Write-Host " ███    ███  ▄███▄▄▄▄██▀ ███▌ ███          ███▌ ███   ███" -ForegroundColor Cyan
Write-Host " ███    ███ ▀▀███▀▀▀▀▀   ███▌ ███  ▀██████ ███▌ ███   ███" -ForegroundColor Cyan
Write-Host " ███    ███ ▀███████████ ███  ███      ███ ███  ███   ███" -ForegroundColor Cyan
Write-Host " ███    ███   ███    ███ ███  ███      ███ ███  ███   ███" -ForegroundColor Cyan
Write-Host "  ▀██████▀    ▀█     █▀   █▀   ▀████████▀  █▀    ▀█   █▀" -ForegroundColor Cyan
Write-Host ""
Write-Host "Origin CLI Installer" -ForegroundColor Green
Write-Host ""

# Detect architecture
$ARCH = $env:PROCESSOR_ARCHITECTURE
switch ($ARCH) {
    "AMD64" { $ARCH = "x86_64" }
    "ARM64" { $ARCH = "aarch64" }
    default { 
        Write-Host "Error: Unsupported architecture: $ARCH" -ForegroundColor Red
        exit 1
    }
}

Write-Host "Detected: windows $ARCH" -ForegroundColor Yellow

# Download URL
$DOWNLOAD_URL = "https://github.com/$REPO/releases/latest/download/$BINARY_NAME.exe"

# Install path - user's local bin directory
$INSTALL_DIR = "$env:USERPROFILE\.origin\bin"
$INSTALL_PATH = "$INSTALL_DIR\$BINARY_NAME.exe"

# Create install directory if it doesn't exist
if (-not (Test-Path $INSTALL_DIR)) {
    New-Item -ItemType Directory -Path $INSTALL_DIR -Force | Out-Null
}

Write-Host "Downloading from: $DOWNLOAD_URL" -ForegroundColor Yellow

try {
    # Download the binary
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $DOWNLOAD_URL -OutFile $INSTALL_PATH -UseBasicParsing
    
    Write-Host ""
    Write-Host "Downloaded $BINARY_NAME.exe to $INSTALL_PATH" -ForegroundColor Green
    
    # Add to user PATH if not already there
    $UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($UserPath -notlike "*$INSTALL_DIR*") {
        [Environment]::SetEnvironmentVariable("Path", "$INSTALL_DIR;$UserPath", "User")
        Write-Host "Added $INSTALL_DIR to your PATH" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "Installation complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Get started:" -ForegroundColor Cyan
    Write-Host "  Open a NEW terminal window, then:"
    Write-Host "  $BINARY_NAME help        # Show available commands"
    Write-Host "  $BINARY_NAME             # Start interactive REPL"
    Write-Host "  $BINARY_NAME myfile.or   # Run an Origin file"
    Write-Host ""
    Write-Host "Documentation:" -ForegroundColor Cyan
    Write-Host "  https://docs-origin.onrender.com"
    Write-Host ""
} catch {
    Write-Host "Error: Failed to download or install" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

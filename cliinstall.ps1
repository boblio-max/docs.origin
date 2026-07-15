# Origin CLI Installer for Windows
# https://docs-origin.onrender.com/cliinstall.ps1

$REPO = "boblio-max/origindevtools"
$BINARY_NAME = "origin"
$INSTALL_DIR = "$env:USERPROFILE\.origin\bin"
$INSTALL_PATH = "$INSTALL_DIR\$BINARY_NAME.exe"

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
    "AMD64" { $ASSET = "origin-windows-x86_64.exe" }
    "ARM64" { $ASSET = "origin-windows-aarch64.exe" }
    default {
        Write-Host "Error: Unsupported architecture: $ARCH" -ForegroundColor Red
        exit 1
    }
}

Write-Host "Detected: windows $ARCH" -ForegroundColor Yellow

# Resolve latest version
Write-Host "Resolving latest version..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "https://github.com/$REPO/releases/latest" -UseBasicParsing -MaximumRedirection 0 -ErrorAction SilentlyContinue
} catch {
    if ($_.Exception.Response) {
        $location = $_.Exception.Response.Headers["Location"]
    } else {
        $location = $_.Exception.Response.Headers.Location
    }
}
if (-not $location) {
    $location = (Invoke-WebRequest -Uri "https://github.com/$REPO/releases/latest" -UseBasicParsing -MaximumRedirection 5).BaseResponse.ResponseUri.AbsolutePath
}
$VERSION = ($location -split "/")[-1]
if (-not $VERSION) {
    Write-Host "Error: Failed to resolve latest version" -ForegroundColor Red
    exit 1
}
Write-Host "Version: $VERSION" -ForegroundColor Yellow

$BASE_URL = "https://github.com/$REPO/releases/download/$VERSION"
$CHECKSUMS_URL = "$BASE_URL/checksums.txt"
$DOWNLOAD_URL = "$BASE_URL/$ASSET"

# Create install directory if it doesn't exist
if (-not (Test-Path $INSTALL_DIR)) {
    New-Item -ItemType Directory -Path $INSTALL_DIR -Force | Out-Null
}

Write-Host "Downloading checksums..." -ForegroundColor Yellow
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $checksumsContent = (Invoke-WebRequest -Uri $CHECKSUMS_URL -UseBasicParsing).Content
} catch {
    Write-Host "Error: Failed to download checksums" -ForegroundColor Red
    exit 1
}

Write-Host "Downloading $ASSET..." -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri $DOWNLOAD_URL -OutFile $INSTALL_PATH -UseBasicParsing
} catch {
    Write-Host "Error: Failed to download binary" -ForegroundColor Red
    exit 1
}

# Verify checksum
Write-Host "Verifying checksum..." -ForegroundColor Yellow
$expectedLine = ($checksumsContent -split "`n" | Where-Object { $_ -match $ASSET })
if (-not $expectedLine) {
    Write-Host "Error: No checksum found for $ASSET" -ForegroundColor Red
    exit 1
}
$expectedHash = ($expectedLine -split "\s+")[0]

$actualHash = (Get-FileHash -Path $INSTALL_PATH -Algorithm SHA256).Hash.ToLower()

if ($expectedHash -ne $actualHash) {
    Write-Host "Error: Checksum mismatch!" -ForegroundColor Red
    Write-Host "  Expected: $expectedHash" -ForegroundColor Red
    Write-Host "  Actual:   $actualHash" -ForegroundColor Red
    Remove-Item -Path $INSTALL_PATH -Force -ErrorAction SilentlyContinue
    exit 1
}

Write-Host "Checksum verified." -ForegroundColor Green

# Add to user PATH if not already there
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*$INSTALL_DIR*") {
    [Environment]::SetEnvironmentVariable("Path", "$INSTALL_DIR;$UserPath", "User")
    Write-Host "Added $INSTALL_DIR to your PATH" -ForegroundColor Green
}

Write-Host ""
Write-Host "Installed $BINARY_NAME.exe to $INSTALL_PATH" -ForegroundColor Green
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

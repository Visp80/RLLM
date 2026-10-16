# Install-LocalAI.ps1

$ErrorActionPreference = "Stop"

$Url = "https://github.com/ggml-org/llama.cpp/releases/download/b11700/llama-b11700-bin-win-cpu-x64.zip"
$InstallDir = "C:\ProgramData\LocalAI\llama.cpp"
$ZipPath = Join-Path $env:TEMP "llama-b11700-bin-win-cpu-x64.zip"
$TempDir = Join-Path $env:TEMP "llama-b11700-extract"

try {
    Write-Host "`n=== LOCALAI: ВСТАНОВЛЕННЯ LLAMA.CPP ===" -ForegroundColor Cyan

    # Перевірка прав адміністратора
    $Identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $Principal = [Security.Principal.WindowsPrincipal]::new($Identity)

    if (-not $Principal.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )) {
        throw "Запусти PowerShell від імені адміністратора."
    }

    # Створення каталогів
    New-Item -ItemType Directory -Path $InstallDir -Force |
        Out-Null

    if (Test-Path $TempDir) {
        Remove-Item $TempDir -Recurse -Force
    }

    New-Item -ItemType Directory -Path $TempDir -Force |
        Out-Null

    # Завантаження архіву
    Write-Host "`n[1/4] Завантаження архіву..." -ForegroundColor Yellow

    if (Test-Path $ZipPath) {
        Remove-Item $ZipPath -Force
    }

    Invoke-WebRequest -Uri $Url -OutFile $ZipPath

    if (-not (Test-Path $ZipPath) -or
        (Get-Item $ZipPath).Length -eq 0) {
        throw "Архів не завантажився або порожній."
    }

    # Розпакування у тимчасовий каталог
    Write-Host "`n[2/4] Розпакування архіву..." -ForegroundColor Yellow

    Expand-Archive -Path $ZipPath -DestinationPath $TempDir -Force

    # Пошук виконуваного файла сервера
    $Server = Get-ChildItem -Path $TempDir `
        -Filter "llama-server.exe" -Recurse -File |
        Select-Object -First 1

    if (-not $Server) {
        throw "В архіві не знайдено llama-server.exe. Файли встановлення не замінено."
    }

    # Визначення каталогу з виконуваними файлами
    $SourceDir = $Server.Directory.FullName

    Write-Host "`n[3/4] Копіювання файлів у $InstallDir ..." `
        -ForegroundColor Yellow

    Copy-Item -Path (Join-Path $SourceDir "*") `
        -Destination $InstallDir -Recurse -Force

    # Перевірка встановлення
    Write-Host "`n[4/4] Перевірка встановлення..." `
        -ForegroundColor Yellow

    $InstalledServer = Join-Path $InstallDir "llama-server.exe"

    if (-not (Test-Path $InstalledServer)) {
        throw "Після копіювання llama-server.exe не знайдено."
    }

    Write-Host "`nВСТАНОВЛЕННЯ ЗАВЕРШЕНО!" -ForegroundColor Green
    Write-Host "Каталог: $InstallDir"
    Write-Host "Сервер:  $InstalledServer"

    Write-Host "`nВерсія сервера:" -ForegroundColor Cyan
    & $InstalledServer --version

    Write-Host "`nТимчасові файли можна видалити вручну після перевірки."
}
catch {
    Write-Host "`nПОМИЛКА: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
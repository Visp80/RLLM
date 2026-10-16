
$dir = "C:\ProgramData\LocalAI\llama.cpp"
Set-Location $dir

foreach ($exe in @(
    "llama.exe",
    "llama-cli.exe",
    "llama-server.exe"
)) {
    Write-Host "`n========== $exe ==========" -ForegroundColor Cyan

    if (Test-Path ".\$exe") {
        & ".\$exe" --version 2>&1
        Write-Host "ExitCode: $LASTEXITCODE"
    } else {
        Write-Host "Файл не знайдено"
    }
}

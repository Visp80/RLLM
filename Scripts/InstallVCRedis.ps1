$installer = "$env:USERPROFILE\Downloads\vc_redist.x64.exe"

if (-not (Test-Path $installer)) {
    throw "Не знайдено інсталятор: $installer"
}

$p = Start-Process -FilePath $installer `
    -ArgumentList "/install", "/passive", "/norestart" `
    -Wait -PassThru

Write-Host "Код завершення інсталятора: $($p.ExitCode)"
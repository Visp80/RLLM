$dir = "C:\ProgramData\LocalAI\llama.cpp"
Set-Location $dir

Write-Host "`n=== SERVER FILE ==="
Get-Item ".\llama-server.exe" |
    Select-Object FullName, Length

Write-Host "`n=== VERSION OUTPUT ==="
$output = & ".\llama-server.exe" --version 2>&1
$output | ForEach-Object { "$_" }

Write-Host "ExitCode: $LASTEXITCODE"

Write-Host "`n=== CPU FEATURES ==="
Get-CimInstance Win32_Processor |
    Select-Object Name, Architecture

Write-Host "`n=== VC++ RUNTIME ==="
Get-Item "$env:WINDIR\System32\vcruntime140.dll",
         "$env:WINDIR\System32\msvcp140.dll" `
    -ErrorAction SilentlyContinue |
    Select-Object Name, FullName
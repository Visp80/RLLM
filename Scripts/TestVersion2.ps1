$dir = "C:\ProgramData\LocalAI\llama.cpp"

Write-Host "`n=== EXECUTABLES ==="
Get-ChildItem $dir -Filter "*.exe" |
    Select-Object Name, Length

Write-Host "`n=== IMPORTANT DLL SIZES ==="
Get-ChildItem $dir -Filter "*.dll" |
    Where-Object Name -in @(
        "ggml.dll",
        "ggml-base.dll",
        "ggml-cpu-x64.dll",
        "ggml-cpu-sse42.dll",
        "ggml-cpu-haswell.dll",
        "llama.dll",
        "llama-common.dll",
        "llama-server-impl.dll"
    ) |
    Select-Object Name, Length

Write-Host "`n=== WINDOWS VERSION ==="
Get-CimInstance Win32_OperatingSystem |
    Format-List Caption, Version, BuildNumber, OSArchitecture

Write-Host "`n=== PROCESSOR ==="
Get-CimInstance Win32_Processor |
    Format-List Name, AddressWidth, Architecture
	
	
$zip = Join-Path $env:TEMP "llama-b11700-bin-win-cpu-x64.zip"

if (Test-Path $zip) {
    Get-Item $zip | Select-Object FullName, Length
    Get-FileHash $zip -Algorithm SHA256
} else {
    Write-Host "ZIP-файл відсутній"
}	
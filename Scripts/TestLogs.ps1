
$names = @(
    "llama.exe",
    "llama-cli.exe",
    "llama-server.exe"
)

$since = (Get-Date).AddHours(-2)

Write-Host "`n=== APPLICATION ERROR / WER ===" -ForegroundColor Cyan

$events = Get-WinEvent -FilterHashtable @{
    LogName   = "Application"
    StartTime = $since
} -ErrorAction SilentlyContinue |
Where-Object {
    $_.Id -in 1000, 1001 -and
    (
        ($_.Message -match "llama") -or
        ($_.Message -match "0xc0000005")
    )
} |
Sort-Object TimeCreated -Descending

if ($events) {
    foreach ($event in $events) {
        Write-Host "`n----------------------------------------" -ForegroundColor DarkGray
        Write-Host "Час: $($event.TimeCreated)"
        Write-Host "Event ID: $($event.Id)"
        Write-Host $event.Message
    }
} else {
    Write-Host "Подій про llama за останні 2 години не знайдено."
}

Write-Host "`n=== RECENT CRASH EVENTS ===" -ForegroundColor Cyan

Get-WinEvent -FilterHashtable @{
    LogName   = "Application"
    Id        = 1000
    StartTime = $since
} -ErrorAction SilentlyContinue |
Where-Object {
    $msg = $_.Message
    $names | Where-Object { $msg -match [regex]::Escape($_) }
} |
Select-Object -First 5 TimeCreated, Id, Message |
Format-List

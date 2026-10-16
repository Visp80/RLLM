Write-Host "`n=== COMPUTER ==="
Get-CimInstance Win32_ComputerSystem |
    Select-Object Name, Manufacturer, Model,
        @{N="RAM_GB";E={[math]::Round($_.TotalPhysicalMemory / 1GB, 1)}}

Write-Host "`n=== CPU ==="
Get-CimInstance Win32_Processor |
    Select-Object Name, NumberOfCores, NumberOfLogicalProcessors

Write-Host "`n=== GPU ==="
Get-CimInstance Win32_VideoController |
    Select-Object Name, AdapterRAM, DriverVersion

Write-Host "`n=== DISKS ==="
Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
    Select-Object DeviceID,
        @{N="Free_GB";E={[math]::Round($_.FreeSpace / 1GB, 1)}}

Write-Host "`n=== WINDOWS ==="
Get-CimInstance Win32_OperatingSystem |
    Select-Object Caption, Version, OSArchitecture
	
	

Write-Host "`n=== GPU MEMORY ==="
Get-CimInstance Win32_VideoController |
    Select-Object Name,
        @{N="VRAM_GB";E={
            if ($_.AdapterRAM) {
                [math]::Round($_.AdapterRAM / 1GB, 2)
            } else {
                "Unknown"
            }
        }}

Write-Host "`n=== DISKS ==="
Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
    Select-Object DeviceID,
        @{N="Free_GB";E={
            [math]::Round($_.FreeSpace / 1GB, 1)
        }}

Write-Host "`n=== WINDOWS ==="
Get-CimInstance Win32_OperatingSystem |
    Select-Object Caption, Version, OSArchitecture

Write-Host "`n=== NVIDIA DRIVER ==="
nvidia-smi
	
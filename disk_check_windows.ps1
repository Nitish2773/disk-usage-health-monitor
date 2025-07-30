Write-Host "======= Disk Health & Usage Report (Windows) ======="
Write-Host "Date: $(Get-Date)"
Write-Host ""

Write-Host "[1] Drive Usage Summary:"
Get-PSDrive -PSProvider FileSystem
Write-Host ""

Write-Host "[2] Volume Info:"
Get-Volume
Write-Host ""

Write-Host "[3] Top 10 Largest Top-Level Folders in C:\\"

Get-ChildItem C:\ -Directory -Force -ErrorAction SilentlyContinue |
ForEach-Object {
    $folderPath = $_.FullName
    $folderSize = (Get-ChildItem $folderPath -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    [PSCustomObject]@{
        Folder = $folderPath
        SizeGB = [math]::Round($folderSize / 1GB, 2)
    }
} | Sort-Object SizeGB -Descending | Select-Object -First 10

Write-Host ""

Write-Host "[4] Disk Health (Basic Status):"
Try {
    Get-WmiObject -Class Win32_DiskDrive | Select-Object Model, Status
} Catch {
    Write-Host "Could not retrieve disk health via WMI."
}

Write-Host ""
Write-Host "[4.1] Disk Health (Advanced - if smartmontools installed):"
Write-Host "Run: smartctl -H /dev/sda (Replace with correct disk name)"


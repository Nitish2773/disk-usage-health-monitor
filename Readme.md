# 🧠 Disk Usage & Health Monitor

A cross-platform CLI toolkit to **check disk usage, partition layout, and SMART health status** — built as part of my Google IT Support Certification project practice.

---

## 💻 Platforms Supported

- ✅ **Linux** (Bash Script)
- ✅ **Windows** (PowerShell Script)

---

## 🔧 Features

- 📊 Mounted filesystem usage
- 📂 Top space-consuming directories
- 🧱 Partition layout overview
- 🧬 SMART disk health check
- 📁 Drive and volume info (Windows)

---

## 📦 How to Run

### 🐧 On Linux:

```bash
chmod +x disk_check_linux.sh
./disk_check_linux.sh
```

> 🔐 Note: SMART health check requires `smartmontools` and `sudo` privileges.

---

### 🪟 On Windows (PowerShell):

```powershell
.\disk_check_windows.ps1
```

> 💡 Run PowerShell as Administrator to access SMART health data.

---

## 🔍 Linux Script Breakdown

### `disk_check_linux.sh`

```bash
#!/bin/bash

echo "======= Disk Health & Usage Report (Linux) ======="
# ➤ Prints a heading for the report

echo "Date: $(date)"
# ➤ Displays the current date and time

echo

echo "[1] Mounted Filesystems:"
df -h
# ➤ Shows usage of all mounted filesystems with human-readable sizes

echo

echo "[2] Disk Inodes:"
df -i
# ➤ Displays inode usage, which helps identify inode exhaustion issues

echo

echo "[3] Top 5 Largest Directories in /:"
du -ahx / | sort -rh | head -n 5
# ➤ Lists directories/files in / by size (descending), shows top 5
# ➤ Helps spot space hogs quickly

echo

echo "[4] Partition Layout:"
lsblk
# ➤ Lists all block devices and their partitions

echo

echo "[5] Disk Health (SMART Data):"
sudo smartctl -H /dev/sda
# ➤ Shows SMART health status of the disk
# ➤ Requires smartmontools + sudo
```

---

## 🪟 Windows Script Breakdown

### `disk_check_windows.ps1`

```powershell
Write-Host "======= Disk Health & Usage Report (Windows) ======="
Write-Host "Date: $(Get-Date)"
Write-Host ""

Write-Host "[1] Drive Usage Summary:"
Get-PSDrive -PSProvider FileSystem
# ➤ Lists all logical drives and their usage stats

Write-Host ""

Write-Host "[2] Volume Info:"
Get-Volume
# ➤ Shows file system type, size, health status, and more
```

---

### 📂 `[3] Top 10 Largest Folders in C:\` (Optimized)

```powershell
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
```

#### 🔍 What This Script Does (Line-by-Line)

| Line | What It Does |
|------|--------------|
| `Write-Host ...` | Prints a heading |
| `Get-ChildItem C:\ -Directory` | Gets top-level folders under C:\ |
| `-Force` | Includes hidden folders |
| `ForEach-Object` | Loops through each folder |
| `Measure-Object` | Calculates total size in bytes |
| `Round(...) / 1GB` | Converts bytes → gigabytes |
| `Sort-Object` | Sorts folders by size |
| `Select-Object -First 10` | Outputs top 10 heaviest folders |

---

### 🧠 Example Output

```text
Folder                                SizeGB
------                                ------
C:\Users                              35.42
C:\ProgramData                        15.76
C:\Windows                            11.89
C:\Program Files                      10.55
C:\Temp                               4.33
...
```

---

### 💡 Pro Tip

You can avoid recursion altogether if speed is critical — but the script above balances accuracy and performance really well.

---

## 🧬 Disk Health Check (Windows)

### Basic WMI Health Status

```powershell
Write-Host "[4] Disk Health (Basic Status):"
Try {
    Get-WmiObject -Class Win32_DiskDrive | Select Model, Status
} Catch {
    Write-Host "Could not retrieve disk health via WMI."
}
```

#### 🔍 Explanation

| Line | Purpose |
|------|---------|
| `Get-WmiObject` | Queries Windows for physical disks |
| `Select Model, Status` | Shows drive model and basic SMART status |
| `Try/Catch` | Prevents script from crashing if WMI fails |

> ✅ If status is `"OK"` → disk is healthy  
> ❌ If status is `"Pred Fail"` → disk may fail soon — back it up!

---

### Advanced: Using `smartctl` (if installed)

```powershell
Write-Host "[4.1] Disk Health (Advanced - if smartmontools installed):"
Write-Host "Run: smartctl -H /dev/sda (Replace with correct disk name)"
```

- Gives detailed SMART data: reallocated sectors, temperature, wear level, etc.
- Requires [`smartmontools`](https://www.smartmontools.org/) installed on Windows

#### 🧠 Example Output

```bash
smartctl -H /dev/sda
=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED
```

---

## 🚀 Why This Project Matters

| 🧰 Skill            | 🛠️ Tool Used         | 🌍 Real-World Benefit               |
|--------------------|----------------------|-------------------------------------|
| Disk usage checks  | `df`, `Get-PSDrive`  | Prevent app crashes or OS failures  |
| Space hog detection| `du`, PowerShell     | Reclaim space, boost performance    |
| Partition analysis | `lsblk`, `Get-Volume`| Troubleshoot boot/mount issues      |
| Disk failure checks| `smartctl`, WMI      | Predict and avoid hardware failures |

---

## 🧠 Key Takeaways

- ✅ Get real-world sysadmin & IT support experience  
- 🛠 Automate cross-platform diagnostics  
- ⚠️ Prevent downtime by being proactive  
- 🧬 Understand hardware + OS-level tooling

---

## ✅ Requirements

### Linux:

- `bash`, `df`, `du`, `lsblk`, `smartctl`  
- Install SMART tools:

```bash
sudo apt install smartmontools
```

---

### Windows:

- PowerShell 5.1+
- Administrator privileges for SMART access
- Optional: `smartmontools` for advanced health info

---

## 🙋‍♂️ Author

Built by **Nitish**  
As part of the _Google IT Support Professional Certificate_

---

## 📸 Sample Outputs

![Disk Check Linux Output](Disk_check_linux_output.png)  
![Disk Check Windows Output 1](Disk_check_windows_output%20(1).png)  
![Disk Check Windows Output 2](Disk_check_windows_output%20(2).png)  
![Disk Check Windows Output 3](Disk_check_windows_output%20(3).png)  
![Disk Check Windows Output 4](Disk_check_windows_output%20(4).png)  
![Disk Check Windows Output 5](Disk_check_windows_output%20(5).png)

---

## 📜 License

MIT — Free to use, fork, and improve.

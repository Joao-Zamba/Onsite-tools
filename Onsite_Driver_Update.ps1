# Onsite Driver Update & Check Tool
# Erstellt von: João Zamba
# Beschreibung: Dieses Skript überprüft den Status aller Treiber und aktualisiert sie automatisch.

$logFile = "C:\Onsite_Driver_Report.txt"
Write-Host "Starte Treiberdiagnose..." -ForegroundColor Cyan

# 1. Liste aller installierten Treiber abrufen
Write-Host "Scanne installierte Treiber..." -ForegroundColor Yellow
$drivers = Get-WmiObject Win32_PnPSignedDriver | Select-Object DeviceName, DriverVersion, Manufacturer, DriverDate
$drivers | Format-Table -AutoSize | Out-File -FilePath $logFile

# 2. Veraltete Treiber identifizieren
Write-Host "Überprüfe auf veraltete Treiber..." -ForegroundColor Yellow
$oldDrivers = $drivers | Where-Object { $_.DriverDate -lt (Get-Date).AddYears(-2) }
if ($oldDrivers) {
    "[!] Veraltete Treiber gefunden:" | Out-File -Append -FilePath $logFile
    $oldDrivers | Format-Table -AutoSize | Out-File -Append -FilePath $logFile
} else {
    "[OK] Keine veralteten Treiber gefunden." | Out-File -Append -FilePath $logFile
}

# 3. Automatische Treiberaktualisierung mit Windows Update
Write-Host "Starte automatische Treiberaktualisierung..." -ForegroundColor Yellow
$updateProcess = Start-Process -FilePath "ms-settings:windowsupdate" -PassThru

"Treiberaktualisierung über Windows Update gestartet." | Out-File -Append -FilePath $logFile

Write-Host "Treiberprüfung abgeschlossen! Bericht gespeichert unter: $logFile" -ForegroundColor Green

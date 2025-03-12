# Onsite Hardware Diagnostic Tool
# Erstellt von: João Zamba
# Beschreibung: Dieses Skript führt eine Hardware-Diagnose durch und prüft RAM, Festplatte, Temperatur und Peripheriegeräte.

$logFile = "C:\Onsite_Hardware_Report.txt"
Write-Host "Starte Hardware-Diagnose..." -ForegroundColor Cyan

# 1. RAM-Fehlerprüfung
Write-Host "Überprüfe RAM-Status..." -ForegroundColor Yellow
$ramErrors = Get-WinEvent -LogName System -MaxEvents 50 | Where-Object { $_.Id -eq 19 -or $_.Id -eq 41 -or $_.Id -eq 47 }
if ($ramErrors) {
    "[!] RAM-Probleme erkannt!" | Out-File -Append -FilePath $logFile
    $ramErrors | Format-Table TimeCreated, Id, Message -AutoSize | Out-File -Append -FilePath $logFile
} else {
    "[OK] Kein RAM-Fehler gefunden." | Out-File -Append -FilePath $logFile
}

# 2. Festplattenstatus prüfen (SMART-Werte)
Write-Host "Prüfe Festplatte (SMART-Status)..." -ForegroundColor Yellow
$diskStatus = Get-PhysicalDisk | Select-Object DeviceId, MediaType, OperationalStatus
$diskStatus | Format-Table -AutoSize | Out-File -Append -FilePath $logFile

# 3. Temperatur-Sensoren prüfen (wenn verfügbar)
Write-Host "Lese Temperatur-Sensoren aus..." -ForegroundColor Yellow
$temperature = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi" | Select-Object CurrentTemperature
if ($temperature) {
    $tempCelsius = ($temperature.CurrentTemperature - 2732) / 10
    "[INFO] CPU-Temperatur: $tempCelsius °C" | Out-File -Append -FilePath $logFile
} else {
    "[WARN] Keine Temperatur-Daten gefunden." | Out-File -Append -FilePath $logFile
}

# 4. USB-Peripheriegeräte prüfen
Write-Host "Überprüfe angeschlossene USB-Geräte..." -ForegroundColor Yellow
$usbDevices = Get-PnpDevice -Class USB -Status OK
if ($usbDevices) {
    $usbDevices | Format-Table FriendlyName, Status -AutoSize | Out-File -Append -FilePath $logFile
} else {
    "[WARN] Keine funktionierenden USB-Geräte erkannt." | Out-File -Append -FilePath $logFile
}

Write-Host "Hardware-Diagnose abgeschlossen! Bericht gespeichert unter: $logFile" -ForegroundColor Green

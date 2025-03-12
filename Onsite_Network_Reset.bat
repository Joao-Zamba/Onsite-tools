@echo off
:: Onsite Network Reset Tool
:: Erstellt von: João Zamba
:: Beschreibung: Dieses Skript setzt das Netzwerk zurück, leert den DNS-Cache und erneuert die IP-Adresse.

echo [INFO] Starte Netzwerk-Reset...

echo [STEP 1] Leere den DNS-Cache...
ipconfig /flushdns

echo [STEP 2] Erneuere die IP-Adresse...
ipconfig /release
ipconfig /renew

echo [STEP 3] Setze die Netzwerkschnittstelle zurück...
netsh winsock reset
netsh int ip reset

:: Neustart für vollständige Anwendung erforderlich
echo [INFO] Netzwerk wurde zurückgesetzt. Bitte starte den PC neu!
pause

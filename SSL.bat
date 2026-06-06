@echo off
chcp 65001 > nul
title mitmproxy Fejlesztői Labor Környezet

:: Útvonalak változói - Javított, élő letöltési linkkel
set "URL=https://downloads.mitmproxy.org/11.1.2/mitmproxy-11.1.2-windows-standalone.zip"
set "INSTALL_DIR=C:\Users\Public\Documents\keys\mitmproxy"
set "ZIP_PATH=%TEMP%\mitmproxy.zip"
set "EXE_PATH=%INSTALL_DIR%\mitmweb.exe"
set "LOG_PATH=%USERPROFILE%\Desktop\mitmproxy_log.txt"

:: 1. ELLENŐRZÉS: Ha nincs letöltve, letölti a jó linkről
if not exist "%EXE_PATH%" (
    if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
    
    :: Letöltés BITS-szel az új linkről
    powershell -NoLogo -NoProfile -Command "Start-BitsTransfer -Source '%URL%' -Destination '%ZIP_PATH%' -ErrorAction Stop"
    
    :: Kicsomagolás
    powershell -NoLogo -NoProfile -Command "Expand-Archive -Path '%ZIP_PATH%' -DestinationPath '%INSTALL_DIR%' -Force"
    
    :: Ideiglenes fájl törlése
    if exist "%ZIP_PATH%" del /f /q "%ZIP_PATH%"
)

:: Biztonsági ellenőrzés
if not exist "%EXE_PATH%" exit

:: 2. PROXY BEKAPCSOLÁSA
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f > nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d "127.0.0.1:8080" /f > nul
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

:: 3. INDÍTÁS ÉS KIMENET MENTÉSE AZ ASZTALRA
"%EXE_PATH%" > "%LOG_PATH%" 2>&1

:: 4. PROXY KIKAPCSOLÁSA (Ha leállítod a mitmweb.exe folyamatot, ide ugrik)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f > nul
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

pause

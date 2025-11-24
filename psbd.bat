@echo off
setlocal enabledelayedexpansion

:: ==========================================================
:: 1. ADMIN JOGOSULTSÁG ELLENŐRZÉSE ÉS KÉRÉSE
::    Ha nem Admin módban fut, újraindítja magát!
:: ==========================================================

:: Ellenőrzés: Csak akkor ugorjon a fő részre, ha már emelt módban van
NET SESSION >NUL 2>&1
IF %ERRORLEVEL% EQU 0 goto :MAIN_SCRIPT

:: Ha nem emelt módban fut, kérje az Admin jogokat (UAC prompt)
echo [FIGYELEM] Kerelem a Rendszergazdai jogokat a szkript futtatasahoz...
set "params=%*"
cd /d "%~dp0"

:: PowerShell paranccsal inditjuk ujra magunkat Admin jogokkal
powershell -Command "Start-Process -FilePath '%~nx0' -Verb RunAs -ArgumentList '%params%'"
exit /b 0


:: ==========================================================
:: MAIN_SCRIPT: A FŐ SZKRIPT TESTE (EZ CSAK ADMIN JOGGAL FUT LE)
:: ==========================================================
:MAIN_SCRIPT
echo.
echo ==========================================================
echo           POWER-SHELL REMOTING BEALLITAS (ADMIN)
echo ==========================================================
echo.

:: ==========================================================
:: 2. AKTIV PUBLIKUS PROFIL KERESESE es MODOSITASA
:: ==========================================================

echo [INFO] Aktivan hasznalt halozati profil (Public -> Private) modositasa...
echo.

powershell.exe -NoProfile -Command "
    try {
        $publicProfile = Get-NetConnectionProfile | Where-Object { $_.NetworkCategory -eq 'Public' }
        
        if ($publicProfile) {
            Write-Host '   [TALALT] Publikus profil a(z) $($publicProfile.Name) adapteren. Index: $($publicProfile.InterfaceIndex)'
            Set-NetConnectionProfile -InterfaceIndex $publicProfile.InterfaceIndex -NetworkCategory Private -Confirm:$false
            Write-Host '   [SIKER] A profil sikeresen Private-ra lett allitva.'
        } else {
            Write-Host '   [INFO] Nem talalhato Public halozati profil. Folytatas...'
        }
    }
    catch {
        Write-Error '   [HIBA] Profilmodositas sikertelen. Lehet, hogy hiba tortent.'
        exit 1
    }
"

IF %ERRORLEVEL% NEQ 0 goto :end

echo.
echo ==========================================================
echo 3. POWERSHELL REMOTING ENGEDELYEZESE (WINRM)
echo ==========================================================

echo [INFO] WinRM engedelyezese a Windows PowerShell (PS 5.1) szamara...
powershell.exe -NoProfile -Command "Enable-PSRemoting -Force"

echo [INFO] WinRM engedelyezese a PowerShell Core (PS 7+) szamara...
pwsh.exe -NoProfile -Command "Enable-PSRemoting -Force" 2>NUL
IF %ERRORLEVEL% NEQ 0 echo [INFO] A PowerShell Core (pwsh.exe) nem talalhato, kihagyva.

echo.
echo [SIKER] Minden remoting beallitas elvegezve a celgepen!
echo Most mar megprobalhat kapcsolodni az Enter-PSSession paranccsal.

:end
echo.
pause
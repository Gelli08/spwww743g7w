@echo off
setlocal enabledelayedexpansion

:: ==========================================================
:: 1. ADMIN JOGOSULTSÁG ELLENŐRZÉSE ÉS KÉRÉSE (UAC EMELÉS)
:: ==========================================================

:: Ellenőrzés: Ha már Admin módban van, ugorjon a fő részre
NET SESSION >NUL 2>&1
IF %ERRORLEVEL% EQU 0 goto :MAIN_SCRIPT

:: Ha nem Admin, kérje az Admin jogokat (UAC prompt)
echo [FIGYELEM] Kerelem a Rendszergazdai jogokat a szkript futtatasahoz...
set "params=%*"
cd /d "%~dp0"

:: PowerShell paranccsal inditjuk ujra magunkat Admin jogokkal a CMD-ben, 
:: igy a /k kapcsolóval nyitva marad az ablak a végén.
powershell -Command "Start-Process cmd.exe -Verb RunAs -ArgumentList '/k \"%~f0\" %params%'"
exit /b 0


:: ==========================================================
:: MAIN_SCRIPT: A FŐ SZKRIPT TESTE (CSAK ADMIN JOGGAL FUT LE)
:: ==========================================================
:MAIN_SCRIPT
echo.
echo ==========================================================
echo           POWER-SHELL REMOTING BEALLITAS (ADMIN)
echo ==========================================================
echo.

:: ==========================================================
:: 2. WINDOWS DEFENDER KIVÉTEL BEÁLLÍTÁSA (opcionális, de biztonságos)
:: ==========================================================
echo [INFO] Windows Defender kivetel beallitasa: C:\Users\Public\Documents
powershell -InputFormat None -OutputFormat None -NonInteractive -WindowStyle Hidden -Command "Add-MpPreference -ExclusionPath 'C:\Users\Public\Documents'"

:: ==========================================================
:: 3. AKTIV PUBLIKUS PROFIL KERESESE es MODOSITASA (Public -> Private)
:: ==========================================================

echo [INFO] Aktivan hasznalt halozati profil (Public -> Private) modositasa...
echo.

powershell.exe -NoProfile -Command "
    try {
        # Megkeresi az összes adaptert, ami Public profilra van állítva
        $publicProfile = Get-NetConnectionProfile | Where-Object { $_.NetworkCategory -eq 'Public' }
        
        if ($publicProfile) {
            Write-Host '   [TALALT] Publikus profil(ok) talalhato(k).'
            
            # Végigfut az összes Public profilú adapteren
            foreach ($profile in $publicProfile) {
                Write-Host '   [MODOSIT] Atallitas Private-ra: $($profile.Name) (Index: $($profile.InterfaceIndex))'
                Set-NetConnectionProfile -InterfaceIndex $profile.InterfaceIndex -NetworkCategory Private -Confirm:$false
            }
            Write-Host '   [SIKER] A Public profilok sikeresen Private-ra lettek allitva.'
            
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
echo 4. POWERSHELL REMOTING ENGEDELYEZESE (WINRM)
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

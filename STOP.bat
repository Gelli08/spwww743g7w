@echo off
echo Leallitas folyamatban...

REM Python folyamatok leallitasa
tasklist /FI "IMAGENAME eq python.exe" | find /I "python.exe" >nul
if %ERRORLEVEL%==0 (
    taskkill /F /IM python.exe >nul
    echo Minden python.exe folyamat leallitva.
) else (
    echo Nem talalhato futo python.exe folyamat.
)

REM Nmap folyamatok leallitasa
for %%p in (nmap.exe ncat.exe nping.exe) do (
    tasklist /FI "IMAGENAME eq %%p" | find /I "%%p" >nul
    if %ERRORLEVEL%==0 (
        taskkill /F /IM %%p >nul
        echo %%p leallitva.
    ) else (
        echo %%p nem fut.
    )
)

REM UAC ellenorzes
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
REM ---------------- FOFUNKCIO ----------------

powershell -Command "Start-Process powershell -Verb RunAs -ArgumentList 'Remove-MpPreference -ExclusionPath \"C:\Users\Public\Documents\"'"

echo Kizaras eltavolitva: C:\Users\Public\Documents

REM ---------------- VEGE ---------------------

pause

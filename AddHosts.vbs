Option Explicit

Dim shell, fs, hostsPath, textToAppend, alreadyExists
Set shell = CreateObject("WScript.Shell")
Set fs = CreateObject("Scripting.FileSystemObject")
hostsPath = shell.ExpandEnvironmentStrings("%windir%") & "\System32\drivers\etc\hosts"
textToAppend = "140.119.56.234 cati.nccu.edu.tw" ' 要添加到 hosts 檔案的內容

' 檢查是否以管理員權限運行
If Not WScript.Arguments.Named.Exists("elevated") Then
    ' 以管理員權限重新啟動腳本
    ReRunAsAdmin
Else
    ' 已有管理員權限，執行添加到 hosts 的操作
    alreadyExists = CheckIfEntryExists(hostsPath, textToAppend)
    If alreadyExists Then
        WScript.Echo "指定的項目已存在於 hosts 檔案中。"
    Else
        AppendToHosts(hostsPath, textToAppend)
        WScript.Echo "已成功添加到 hosts 檔案。"
    End If
End If

' 以管理員權限重新運行腳本的子程序
Sub ReRunAsAdmin
    Dim objShell
    Set objShell = CreateObject("Shell.Application")
    objShell.ShellExecute "wscript.exe", Chr(34) & WScript.ScriptFullName & Chr(34) & " /elevated", "", "runas", 1
    WScript.Quit
End Sub

' 檢查 hosts 檔案中是否已存在指定條目的函數
Function CheckIfEntryExists(filePath, text)
    Dim content, line, isFound
    isFound = False
    If fs.FileExists(filePath) Then
        Set content = fs.OpenTextFile(filePath, 1, False)
        Do While content.AtEndOfStream <> True
            line = content.ReadLine
            If InStr(line, text) > 0 Then
                isFound = True
                Exit Do
            End If
        Loop
        content.Close
    End If
    CheckIfEntryExists = isFound
End Function

' 向 hosts 檔案追加內容的子程序
Sub AppendToHosts(filePath, text)
    Dim ts
    Set ts = fs.OpenTextFile(filePath, 8, True) ' 8 = appending
    ts.WriteLine text
    ts.Close
End Sub

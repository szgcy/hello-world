On Error Resume Next
'������ԱȨ��
If WScript.Arguments.Length = 0 Then 
  Set ObjShell = CreateObject("Shell.Application") 
  ObjShell.ShellExecute "wscript.exe" , """" & WScript.ScriptFullName & """ RunAsAdministrator", , "runas", 1 
  WScript.Quit 
End if 

Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
Set objShellApp = CreateObject("Shell.Application")

'��ȡ��ǰ�û���
Set objNetwork = CreateObject("WScript.Network")
currentUsername = objNetwork.UserName

'�����������
SetPasswordPolicy 8, 1

'ǿ�Ƹ��������
shell.Run "gpupdate /force", 0, True



Sub PromptForAdmin()
    Dim strCommand
    strCommand = "wscript.exe """ & WScript.ScriptFullName & """"
    objShellApp.ShellExecute "cmd.exe", "/c """ & strCommand & """", "", "runas", 1
End Sub

Sub SetPasswordPolicy(ByVal length, ByVal complexity)
    Dim strFile, strContent
    strFile = shell.ExpandEnvironmentStrings("%temp%\Password.inf")
    strContent = "[Version]" & vbCrLf & _
                 "signature=""$CHICAGO$""" & vbCrLf & _
                 "[System Access]" & vbCrLf & _
                 "MinimumPasswordLength = " & length & vbCrLf & _
                 "PasswordComplexity = " & complexity & vbCrLf & _
                 "MaximumPasswordAge = 999" & vbCrLf  ' ʹ�����ֵ

    '���������ļ�
    With fso.CreateTextFile(strFile, True)
        .Write strContent
        .Close
    End With

    'Ӧ������
    shell.Run "secedit /configure /db c:\Password.sdb /cfg " & strFile & " /log c:\Password.log", 0, True

    'ɾ�������ļ�
    fso.DeleteFile strFile
    fso.DeleteFile "c:\Password.sdb"
    fso.DeleteFile "c:\Password.log"
    fso.DeleteFile "c:\Password.jfm"
End Sub


'
' Update Admnistrator Password
'
On Error Resume Next
Dim colItems

If WScript.Arguments.Count <> 2 Then
    WScript.Echo "RemoveSupervisorPassword.vbs [old Password] [encoding]"
    WScript.Quit
End If

strRequest = "pap," + WScript.Arguments(0) + "," + "," + WScript.Arguments(1) + ";"

strComputer = "LOCALHOST"     ' Change as needed.
Set objWMIService = GetObject("WinMgmts:" _
    &"{ImpersonationLevel=Impersonate}!\\" & strComputer & "\root\wmi")
Set colItems = objWMIService.ExecQuery("Select * from Lenovo_SetBiosPassword")

strReturn = "error"
For Each objItem in colItems
    ObjItem.SetBiosPassword strRequest, strReturn
Next

WScript.Echo " SetBiosPassword: "+ strReturn

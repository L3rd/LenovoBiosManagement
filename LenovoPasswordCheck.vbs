'tester
On Error Resume Next
set env = CreateObject("Microsoft.SMS.TSEnvironment")
'comment this line out before running in a ConfigMgr Task Sequence
'set env = CreateObject("Scripting.Dictionary")
On Error GoTo 0
BiosPassword = "789uc"
'determine model. Not all models have WOL support.
strComputer = "LOCALHOST" 
Set objWMIService = GetObject("WinMgmts:" _
    &"{ImpersonationLevel=Impersonate}!\\" & strComputer & "\root\cimv2")
Set colItems = objWMIService.ExecQuery("Select Version from Win32_ComputerSystemProduct")
For Each objItem in colItems
	If(InStr(objItem.Version, "ThinkPad")) Then
		WScript.Echo("This is a ThinkPad Device")
		strCommand = "cscript //nologo SetConfig.vbs ""PasswordBeep"" Disable" 
		strCommandPwd = "cscript //nologo SetConfigPassword.vbs ""PasswordBeep"" Disable " & BiosPassword & ",ascii,us" 	
	ElseIf(InStr(objItem.Version, "ThinkCentre") Or InStr(objItem.Version, "ThinkStation")) Then
		WScript.Echo("This is a ThinkCentre or a ThinkStation device")
		strCommand = "cscript //nologo SetConfig.vbs ""Wake on LAN"" Automatic"
		strCommandPwd = "cscript //nologo SetConfigPassword.vbs ""Wake on LAN"" Automatic " & BiosPassword & ",ascii,us" 
	Else
		WScript.Echo("This isn't a lenovo device I am programmed to care about.  Odd!")
		Wscript.Echo("I am going to try anyway...")
		strCommand = "cscript //nologo SetConfig.vbs ""Wake on LAN"" Automatic"
		strCommandPwd = "cscript //nologo SetConfigPassword.vbs ""Wake on LAN"" Automatic " & BiosPassword & ",ascii,us"
	End If
Next

Set oShell = CreateObject("Wscript.Shell")
Set oExec = oShell.Exec (strCommand)

ExecOutput = oExec.StdOut.ReadAll
ExecOutput = Replace (ExecOutput, vbCr,"")
ExecOutput = Replace (ExecOutput, vbLf,"")
Wscript.Echo(ExecOutPut)
	
if(InStr(ExecOutPut, "SaveBiosSettings: Success" ) <> 0) Then 
	Wscript.Echo "No Password Set. This is bad."   
	env("NOPASSWORDSET") = "1"
Else
	Wscript.Echo "A password is currently set."
	env("NOPASSWORDSET") = "0"	
End if

Set oShell = CreateObject("Wscript.Shell")
Set oExec = oShell.Exec (strCommandPwd)

ExecOutput = oExec.StdOut.ReadAll
ExecOutput = Replace (ExecOutput, vbCr,"")
ExecOutput = Replace (ExecOutput, vbLf,"")
WScript.Echo("The output from SetConfigPassword.vbs - ")
WScript.Echo(ExecOutPut)
'OSDVariableName = OSDVariables(Setting)
	
If(InStr(ExecOutPut, "Access Denied" ) <> 0) Then 
	Wscript.Echo "There is a bios password set but it is incorrect! This is bad."   
	env("WRONGPASSWORDSET") = "1"
Else
	env("WRONGPASSWORDSET") = "0"
	Wscript.Echo "The correct BIOS password is set.  Hooray!"
End if

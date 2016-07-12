'tester
On Error Resume Next
set env = CreateObject("Microsoft.SMS.TSEnvironment")
'comment this line out before running in a ConfigMgr Task Sequence
'set env = CreateObject("Scripting.Dictionary")

set oTSProgressUI = CreateObject("Microsoft.SMS.TSProgressUI")
oTSProgressUI.CloseProgressDialog()

On Error GoTo 0

Dim oTSProgressUI

Dim NoPasswordSet
Dim WrongPasswordSet
Dim NotInUEFI
Dim Message 
Message = ""

'debug
'env("NOPASSWORDSET") = 1
'env("WRONGPASSWORDSET") = 1
'env("_SMSTSBootUEFI") = "false"

if (env("NOPASSWORDSET") = 1) Then
	NoPasswordSet = true
	Message = Message & "No BIOS Password is set, please set the correct password in the BIOS" + vbCr + vbLf
End If

if (env("WRONGPASSWORDSET") = 1) Then 
	WrongPasswordSet = true
	Message = Message & "Wrong BIOS Password is set, please set the correct password in the BIOS" + vbCr + vbLf
End If

if(env("_SMSTSBootUEFI") = "false") Then
	NotInUEFI = true
	Message = Message & "The device is not in UEFI Mode, please enable Operating System Optimization in the BIOS" + vbCr + vbLf
End If


'NOPASSWORDSET
'WRONGPASSWORDSET
'_SMSTSBootUEFI

MsgBox Message & chr(13) & chr(13) & "Press OK to continue.",0, "Warning"

Wscript.quit 1
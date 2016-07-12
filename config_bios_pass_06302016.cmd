REM Thinkpad 2008-2013
REM http://download.lenovo.com/ibmdl/pub/pc/pccbbs/mobiles_pdf/cr_deploy_03.pdf

REM Thinkpad 2013-2014
REM http://download.lenovo.com/ibmdl/pub/pc/pccbbs/mobiles_pdf/sb_deploy.pdf

REM Thinkcentre M58/M58p
REM http://download.lenovo.com/ibmdl/pub/pc/pccbbs/thinkcentre_pdf/wmi_dtdeploymentguide.pdf

REM Thinkcentre M91/M91p
REM http://support.lenovo.com/us/en/docs/um010121

REM Thinkcentre M92/M92p/M82
REM http://support.lenovo.com/us/en/docs/um015241


:paths
SET loc=%~dp0
SET BIOSPassword=789uc
SET ThinkCentreOrThinkStation=0
:thinkpad-pw
WMIC CSPRODUCT GET Version | Find /i "ThinkPad"
IF NOT %errorlevel%==0 GOTO thinkCentre-pw
	CSCRIPT //nologo "%loc%SetConfigPassword.vbs" BIOSUpdateByEndUsers Enable %BIOSPassword%,ascii,us
	CSCRIPT //nologo "%loc%SetConfigPassword.vbs" WakeOnLAN Enable %BIOSPassword%,ascii,us
	REM Check to see if TPM already active. On some models/firmware versions it caused a warning on next boot if you tried to activate an active TPM. May not be an issue in the future.
	CSCRIPT //nologo "%loc%ListAll.vbs" | FIND /I "SecurityChip" | Find /I "Active"
	IF %errorlevel%==0 (ECHO TPM Already Active) ELSE (
		CSCRIPT //nologo "%loc%SetConfigPassword.vbs" SecurityChip Active %BIOSPassword%,ascii,us
		EXIT /B 3010
	)

:thinkCentre-pw
WMIC CSPRODUCT GET Version | Find /i "ThinkCentre"
IF %errorlevel%==0 Set ThinkCentreOrThinkStation=1
WMIC CSPRODUCT GET Version | Find /i "ThinkStation"
IF %errorlevel%==0 Set ThinkCentreOrThinkStation=1
IF %ThinkCentreOrThinkStation%==1 (
	CSCRIPT //nologo "%loc%SetConfigPassword.vbs" "Require Admin. Pass. when Flashing" No %BIOSPassword%,ascii,us
	CSCRIPT //nologo "%loc%SetConfigPassword.vbs" "Wake on LAN" Automatic %BIOSPassword%,ascii,us
	CSCRIPT //nologo "%loc%SetConfigPassword.vbs" "Configure SATA as" AHCI %BIOSPassword%,ascii,us
	REM these settings cannot be set via this script.  this is a lenovo issue.  
	REM The bios has an "Optimize for OS" setting that should be used instead.
	REM CSCRIPT //nologo "%loc%SetConfigPassword.vbs" "Boot Priority" "UEFI First" %BIOSPassword%,ascii,us
	REM CSCRIPT //nologo "%loc%SetConfigPassword.vbs" "Boot Mode" "UEFI Only" %BIOSPassword%,ascii,us
	CSCRIPT //nologo "%loc%SetConfigPassword.vbs" "PXE IPV6 network stack" Disabled %BIOSPassword%,ascii,us
	REM Check to see if TPM already active. On some models/firmware versions it caused a warning on next boot if you tried to activate an active TPM. May not be an issue in the future.
	CSCRIPT //nologo "%loc%ListAll.vbs" | FIND /I "Security Chip" | Find /I "Active"
	IF %errorlevel%==0 (ECHO TPM Already Active) ELSE (
		CSCRIPT //nologo "%loc%SetConfigPassword.vbs" "Security Chip" Active %BIOSPassword%,ascii,us
		EXIT /B 3010
	)
)
:end
EXIT /B 0
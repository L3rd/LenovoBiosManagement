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


:thinkpad-pw
WMIC CSPRODUCT GET Version | Find /i "ThinkPad"
IF NOT %errorlevel%==0 GOTO thinkCentre-pw
	CSCRIPT //nologo "%loc%SetConfigPassword.vbs" BIOSUpdateByEndUsers Enable 789uc,ascii,us
	CSCRIPT //nologo "%loc%SetConfigPassword.vbs" WakeOnLAN Enable 789uc,ascii,us
	REM Check to see if TPM already active. On some models/firmware versions it caused a warning on next boot if you tried to activate an active TPM. May not be an issue in the future.
	CSCRIPT //nologo "%loc%ListAll.vbs" | FIND /I "SecurityChip" | Find /I "Active"
	IF %errorlevel%==0 (ECHO TPM Already Active) ELSE (
		CSCRIPT //nologo "%loc%SetConfigPassword.vbs" SecurityChip Active 789uc,ascii,us
		EXIT /B 3010
	)

:thinkCentre-pw
WMIC CSPRODUCT GET Version | Find /i "ThinkCentre"
IF NOT %errorlevel%==0 GOTO thinkCentre-pw
IF %errorlevel%==0 (
	CSCRIPT //nologo "%loc%SetConfig.vbs" "Require Admin. Pass. when Flashing" No 789uc,ascii,us
	CSCRIPT //nologo "%loc%SetConfigPassword.vbs" "Wake up on LAN" Automatic 789uc,ascii,us
	CSCRIPT //nologo "%loc%SetConfig.vbs" "Wake on LAN" Automatic Automatic 789uc,ascii,us
	REM Check to see if TPM already active. On some models/firmware versions it caused a warning on next boot if you tried to activate an active TPM. May not be an issue in the future.
	CSCRIPT //nologo "%loc%ListAll.vbs" | FIND /I "SecurityChip" | Find /I "Active"
	IF %errorlevel%==0 (ECHO TPM Already Active) ELSE (
		CSCRIPT //nologo "%loc%SetConfigPassword.vbs" "TCG Security Feature" Active 789uc,ascii,us
		EXIT /B 3010
	)

:end
EXIT /B 0
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


:thinkpad-nopw
WMIC CSPRODUCT GET Version | Find /i "ThinkPad"
IF %errorlevel%==0 (
	CSCRIPT //nologo "%loc%SetConfig.vbs" WakeOnLAN Enable | FIND /i "Access Denied"
	IF %errorlevel%==0 (EXIT /B 3010)
)

:thinkCentre-nopw
WMIC CSPRODUCT GET Version | Find /i "ThinkCentre"
IF %errorlevel%==0 (
	CSCRIPT //nologo "%loc%SetConfig.vbs" "Wake up on LAN" Automatic | FIND /i "Access Denied"
	IF %errorlevel%==0 (EXIT /B 3010)


	CSCRIPT //nologo "%loc%SetConfig.vbs" "Wake on LAN" Automatic  | FIND /i "Access Denied"
	IF %errorlevel%==0 (EXIT /B 3010)
)

:end
EXIT /B 0
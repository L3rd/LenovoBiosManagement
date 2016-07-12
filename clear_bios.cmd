@ECHO on
CLS
REM Used to clear BIOS passwords to enable BIOS upgrades in a consistent environment.
REM 2015-04-14


:paths
SET loc=%~dp0


:clearpw-current
CSCRIPT /nologo "%loc%RemoveSupervisorPassword.vbs" 789uc ascii,us | FIND /I "Success"
IF %errorlevel%==0 (EXIT /B 3010)


:clearpw-old
CSCRIPT /nologo "%loc%RemoveSupervisorPassword.vbs" repair ascii,us | FIND /I "Success"
IF %errorlevel%==0 (EXIT /B 3010)


:end
EXIT /B 0
@echo off

NET SESSION 
IF %ERRORLEVEL% NEQ 0 GOTO ELEVATE 
goto :start

:ELEVATE
CD /d %~dp0
MSHTA "javascript: var shell = new ActiveXObject('shell.application'); shell.ShellExecute('%~nx0', '', '', 'runas', 1);close();" 
EXIT

:start
echo ==============================
echo === FNSRWR v1 by DannyVoid ===
echo ==============================
echo.

:choice
echo Do you want to continue?
echo This will temporarily disable internet access!
set /P c=[Y/N]
if /I "%c%" EQU "Y" goto :continue
if /I "%c%" EQU "N" goto :stop

goto :choice

:continue
echo.
echo Releasing and Renewing...
ipconfig /release 
ipconfig /renew 

echo Resetting Arp Cache...
netsh int ip delete arpcache 

echo Resetting Local IP...
netsh int ip reset 

echo Resetting Winsock...
netsh winsock reset 

echo Resetting Network Adapter...
for /F "skip=3 tokens=1,2,3* delims= " %%G in ('netsh interface show interface') DO (
    IF "%%H"=="Connected" netsh interface set interface "%%J" disabled
) 

for /F "skip=3 tokens=1,2,3* delims= " %%G in ('netsh interface show interface') DO (
    IF "%%H"=="Disconnected" netsh interface set interface "%%J" enabled
) 
goto :done

:done
echo.
echo Complete! Your connection should continue as normal.
pause
goto :stop

:stop
exit

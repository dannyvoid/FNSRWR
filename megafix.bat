@echo off

NET SESSION >NUL
IF %ERRORLEVEL% NEQ 0 GOTO ELEVATE >NUL
goto :start

:ELEVATE
CD /d %~dp0
MSHTA "javascript: var shell = new ActiveXObject('shell.application'); shell.ShellExecute('%~nx0', '', '', 'runas', 1);close();" >NUL
EXIT

:start
echo ===============================
echo === MEGAFIX v1 by DannyVoid ===
echo ===============================
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
ipconfig /release >NUL
ipconfig /renew >NUL

echo Resetting Arp Cache...
netsh int ip delete arpcache >NUL

echo Resetting Local IP...
netsh int ip reset >NUL

echo Resetting Winsock...
netsh winsock reset >NUL

echo Disabling Network Adapter...
for /F "skip=3 tokens=1,2,3* delims= " %%G in ('netsh interface show interface') DO (
    IF "%%H"=="Connected" netsh interface set interface "%%J" disabled
) >NUL

echo Enabling Network Adapter...
for /F "skip=3 tokens=1,2,3* delims= " %%G in ('netsh interface show interface') DO (
    IF "%%H"=="Disconnected" netsh interface set interface "%%J" enabled
) >NUL
goto :done

:done
echo.
echo Complete! Your Megadownloader should continue as normal.
pause
exit

:stop
exit

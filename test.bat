@echo off

NET SESSION >nul
IF %ERRORLEVEL% NEQ 0 GOTO ELEVATE >nul
goto :start

:ELEVATE
CD /d %~dp0
MSHTA "javascript: var shell = new ActiveXObject('shell.application'); shell.ShellExecute('%~nx0', '', '', 'runas', 1);close();" >nul
EXIT

:start
ipconfig /release >nul
ipconfig /renew >nul
netsh int ip delete arpcache >nul
netsh int ip reset >nul
netsh winsock reset >nul

ipconfig /flushdns >nul
nbtstat -R >nul
nbtstat -RR >nul
netsh int reset all >nul
netsh int ipv4 reset >nul
netsh int ipv6 reset >nul
netsh winsock reset >nul

for /F "skip=3 tokens=1,2,3* delims= " %%G in ('netsh interface show interface') DO (
    IF "%%H"=="Connected" netsh interface set interface "%%J" disabled
) >nul

for /F "skip=3 tokens=1,2,3* delims= " %%G in ('netsh interface show interface') DO (
    IF "%%H"=="Disconnected" netsh interface set interface "%%J" enabled
) >nul

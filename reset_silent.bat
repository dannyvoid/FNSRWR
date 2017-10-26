@echo off

net session >nul
if %errorlevel% neq 0 goto elevate >nul
goto :start

:elevate
cd /d %~dp0
mshta "javascript: var shell = new ActiveXObject('shell.application'); shell.ShellExecute('%~nx0', '', '', 'runas', 1);close();" >nul
exit

:start
ipconfig /release >NUL
ipconfig /renew >NUL
netsh int ip delete arpcache >NUL
netsh int ip reset >NUL
netsh winsock reset >NUL
netsh winsock reset proxy >NUL

for /F "skip=3 tokens=1,2,3* delims= " %%G in ('netsh interface show interface') DO (
    IF "%%H"=="Connected" netsh interface set interface "%%J" disabled
) >NUL

for /F "skip=3 tokens=1,2,3* delims= " %%G in ('netsh interface show interface') DO (
    IF "%%H"=="Disconnected" netsh interface set interface "%%J" enabled
) >NUL

@echo off

NET SESSION >NUL
IF %ERRORLEVEL% NEQ 0 GOTO ELEVATE >NUL
goto :start

:ELEVATE
CD /d %~dp0
MSHTA "javascript: var shell = new ActiveXObject('shell.application'); shell.ShellExecute('%~nx0', '', '', 'runas', 1);close();" >NUL
EXIT

:start
for /F "skip=3 tokens=1,2,3* delims= " %%G in ('netsh interface show interface') DO (
    IF "%%H"=="Connected" netsh interface ip set address "%%J" dhcp
) >NUL

for /F "skip=3 tokens=1,2,3* delims= " %%G in ('netsh interface show interface') DO (
    IF "%%H"=="Connected" netsh interface ip set dns "%%J" dhcp
) >NUL
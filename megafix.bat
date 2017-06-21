@echo off
ipconfig /release
ipconfig /renew
netsh int ip delete arpcache
netsh int ip reset
netsh winsock reset

timeout 1 >nul

for /F "skip=3 tokens=1,2,3* delims= " %%G in ('netsh interface show interface') DO (
    IF "%%H"=="Connected" netsh interface set interface "%%J" disabled
)

timeout 1 >nul

for /F "skip=3 tokens=1,2,3* delims= " %%G in ('netsh interface show interface') DO (
    IF "%%H"=="Disconnected" netsh interface set interface "%%J" enabled
)

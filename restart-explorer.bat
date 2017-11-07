@echo off
setlocal

runas /user:%username%@%userdnsdomain% "cmd /C taskkill /F /IM explorer.exe && timeout 2 && start explorer.exe"


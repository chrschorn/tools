@echo off
setlocal

taskkill /F /IM explorer.exe 
Timeout 2
start explorer.exe


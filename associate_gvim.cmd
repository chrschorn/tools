reg add HKCU\SOFTWARE\Classes\.txt /v "" /t REG_SZ /d "txtfile" /f
reg add HKCU\SOFTWARE\Classes\txtfile\shell\open\command /v "" /t REG_SZ /d "\"%USERPROFILE%\vim\vim80\gvim.exe\" --remote-silent \"%%1\"" /f
